Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E75E118173
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfLJHkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:40:00 -0500
Received: from first.geanix.com ([116.203.34.67]:43376 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfLJHkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 02:40:00 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id C9447415;
        Tue, 10 Dec 2019 07:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575963575; bh=/X2wh7Aqojci39EYRELV0KD06CaaYcZS5lrxkGROb1o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FfBQQ0tbaQtw0zEShUzqGm2+NsPKbA+OxieDiUFSqsodYN5UsTenDbEHWGCZCiNV5
         4X5efLynHlqFR1QhKOLC9GzI6XO69dx5zIvXsdTSM0VrKpUGHM0uR4GGxiZ1imHDVc
         g8jkejgGctH5v4mzzJnaIE0LZ2QnMuzTcuEEEOLNxlzuV0tCPbih9C4/sCVyFVItyg
         USyPjWjbQCcPlJN8TgyAzUUMMQDmDRIdZyiYin8Ii0Jjy3uxCOHFiBuMGDCr6ZMMq2
         gUAYDNeNI927e1t6pL2Kj7bxf4M47+vBNlj7KbUw+z/8VB/HUvgKFaYdFFqCSCERwY
         c31dJUQikRFZA==
Subject: Re: [PATCH 2/2] can: flexcan: disable clocks during stop mode
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
 <20191210071252.26165-2-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <0035862d-f202-4a54-0ca0-92bec5dc7063@geanix.com>
Date:   Tue, 10 Dec 2019 08:39:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210071252.26165-2-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2019 08.16, Joakim Zhang wrote:
> Disable clocks during CAN in stop mode.
> 

Hi Joakim

I hope I can get time to test this patchset during this week :-)

/Sean
