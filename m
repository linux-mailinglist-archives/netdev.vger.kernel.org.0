Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD13613D90D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 12:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAPLdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 06:33:38 -0500
Received: from delivery.mailspamprotection.com ([184.154.136.84]:59963 "EHLO
        delivery.mailspamprotection.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbgAPLdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 06:33:37 -0500
X-Greylist: delayed 1256 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jan 2020 06:33:37 EST
Received: from ns1.sm9.siteground.biz ([119.81.84.157] helo=sm9.siteground.biz)
        by se13.mailspamprotection.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <francesca@gew.com.tw>)
        id 1is31Q-0004q4-O3; Thu, 16 Jan 2020 05:09:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gew.com.tw;
         s=default; h=Message-ID:Reply-To:Subject:To:From:Date:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i0+N+us8sAOdsFgQhVxD9RyHO8b3fUk3ZyOW0KONAVE=; b=KnvzOKl2PtfM/kmpeVD/dMgDWD
        0cL9hkZR4CVAPc0pdFzGZ7h+LBBqB7jOxwmSOh8x0bj34Wrqr3vNRb04bgE07nNORmeEAJ2lKnLMy
        6L05xyO/p6sqHPZeoUaz086Geoe6/b7DOUnCb3r/vI5YB6T5KYzYDNwwzj2Q8sq11jDPFbWOZCLIa
        BHsRP40Jq2YvaP7JHpd4EBGjQNuefQU1WXnqesQjBye4HcgU9iwTivFhkx4VdMUSgicAeAekNaqMq
        ac4rpzxgQbK31JMq+yF7od/Yrs4outRnK4iiGSJCwPUoI5Vc92kA4n3HSE/BEP0/6w0nwcfM5VG5U
        8BFJxoTw==;
Received: from [127.0.0.1] (port=42078 helo=securesm9.sgcpanel.com)
        by sm9.siteground.biz with esmtpa (Exim 4.90devstart-1178-b07e68e5-XX)
        (envelope-from <francesca@gew.com.tw>)
        id 1is30s-0000SV-48; Thu, 16 Jan 2020 19:08:34 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 16 Jan 2020 19:08:34 +0800
From:   Francesca Barnes <francesca@gew.com.tw>
To:     undisclosed-recipients:;
Subject: Re: Confirm
Reply-To: frncscbarnes@gmail.com
Mail-Reply-To: frncscbarnes@gmail.com
Message-ID: <ea9774aef405b2db189e0c08fbee75c8@gew.com.tw>
X-Sender: francesca@gew.com.tw
User-Agent: Roundcube Webmail/1.2.4
X-Originating-IP: 119.81.84.157
X-SpamExperts-Domain: sm9.siteground.biz
X-SpamExperts-Username: 119.81.84.157
Authentication-Results: mailspamprotection.com; auth=pass smtp.auth=119.81.84.157@sm9.siteground.biz
X-SpamExperts-Outgoing-Class: unsure
X-SpamExperts-Outgoing-Evidence: Combined (0.56)
X-Recommended-Action: accept
X-Filter-ID: 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
X-Report-Abuse-To: spam@quarantine1.mailspamprotection.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-- 
Hello,

Kindly recheck your email, i sent you an email few days ago but have't
seen any reply from you.

Thanks
Francesca Barnes
