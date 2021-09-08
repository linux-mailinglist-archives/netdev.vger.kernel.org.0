Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCD403436
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 08:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347708AbhIHGWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 02:22:36 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53730 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbhIHGWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 02:22:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631082084; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=TzsX5eejCGRkn41+A5EeEvv+e8xkszYmuNBsdRhsfBk=;
 b=cwzEhLoySahOwZiQvYl2d1V8oYzzw3WvTth6S6+lNd9IddoPotqZIcrviSHTBRE3d+e4AlXy
 zG85uw7KrwHgiXJDxm6S95iIW/QrG7UE68+G/+pMAvSl6TzmifdOAI1hOMlJi2Mi4bKstd4T
 +UYT13d/ibtnvWQkB4OYdwAJehY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 613856646fc2cf7ad9706faf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 08 Sep 2021 06:21:24
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2549FC43635; Wed,  8 Sep 2021 06:21:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 982C6C4338F;
        Wed,  8 Sep 2021 06:21:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 08 Sep 2021 00:21:12 -0600
From:   subashab@codeaurora.org
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAGRyCJGCT5GgFQOCb01zotGBpC66-r2X7EVru-S04i=Sgw9CSA@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
 <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
 <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
 <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
 <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
 <87sfzlplr2.fsf@miraculix.mork.no>
 <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
 <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
 <7aac9ee90376e4757e5f2ebc4948ebed@codeaurora.org>
 <87tujtamk5.fsf@miraculix.mork.no>
 <CAGRyCJGCT5GgFQOCb01zotGBpC66-r2X7EVru-S04i=Sgw9CSA@mail.gmail.com>
Message-ID: <4e1ce15e24e0cee183a1c96cda04324e@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have done a bit of testing both with qmi_wwann qmap implementation
> and rmnet, so far everything seems to be working fine.
> 
> Thanks,
> Daniele

Thanks, I'll send out the patch with additional sysfs once net-next
is open.

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
