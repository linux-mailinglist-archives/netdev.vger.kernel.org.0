Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48810AA9B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 07:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfK0GMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 01:12:49 -0500
Received: from first.geanix.com ([116.203.34.67]:57816 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfK0GMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 01:12:49 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 0928893B1C;
        Wed, 27 Nov 2019 06:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574834944; bh=emaCv2J/HHG0hWeBdetGv++669/Op4JbuFqbXvfzMrY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JiLeNeeG1zjXa+qq+M6lYOIR0LUax596aJIruSTqO21+KrggRfsxonHoJ+PCZcUOL
         hb+8LP8vrwNgYDYzVpdiEQ7AJ231cATtlC76V0WKRTQMIUgisuGUri2O6ufzqw2D5J
         Y4ri/ZH2PHuA9o1/AZx5q8KLInW4jDY+JAgKpWYkrmUK6R/NmsVq7i+n/MKGfegKC9
         LA4oVJ/LMDXa3w0c8TcVd7tS8/IVMRrD36nRil+/mZkQ1Qab+x61Hpa4MCWOhxvnBy
         bo0zNa72MIQWkf7cvwmkhzw1NP+JPXiupqAxtH+jONeIib9tblmsIKiqcrM2p4JmWv
         jV/E2p68hqucg==
Subject: Re: [PATCH V2 0/4] can: flexcan: fixes for stop mode
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
Date:   Wed, 27 Nov 2019 07:12:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b0d531b295e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/11/2019 06.56, Joakim Zhang wrote:
> 	Could you help check the patch set? With your suggestions, I
> have cooked a patch to exit stop mode during probe stage.
> 
> 	IMHO, I think this patch is unneed, now in flexcan driver,
> enter stop mode when suspend, and then exit stop mode when resume.
> AFAIK, as long as flexcan_suspend has been called, flexcan_resume will
> be called, unless the system hang during suspend/resume. If so, only
> code reset can activate OS again. Could you please tell me how does CAN
> stucked in stop mode at your side?

Hi Joakim,

Thanks I'll test this :-)
Guess I will have do some hacking to get it stuck in stop mode.

We have a lot of devices in the field that doesn't have:
"can: flexcan: fix deadlock when using self wakeup"

And they have traffic on both CAN interfaces, that way it's quite easy 
to get them stuck in stop mode.

/Sean
