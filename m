Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75142ADC89
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgKJRAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:00:46 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:35326 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJRAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605027641;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=NKr8r0uLV1nrrcxOSMeIVZxDvBadzfVs2IXxp0zJ7G4=;
        b=aeZYtE/QLgan7NwC7PN+raBXp9FTLK9CJvkFDeVR3TyIKu21ZSmf+lRwyyZBGlLVYw
        Vq7Y2MFkKRjCFgIBzPPBoFMs7I9MeDEJ3sMFcsHe5XCUEYRljnghyJOy1uZgy9VTQHAV
        Gg6BiIp6Pznga/4npAjAcu2ObX5LopOZMrGdaXOJViVdkA1IWdIZYBEOBAmb3enXHpjq
        cf6xY/DFOyC5JQi/PbHMU8BQtK9XTn10CuLWZjo1uCKiU7MYaCppTI/HQMjT3fwFTHvc
        rZYxu/YlmmZoBkx6cDJ/B+ShT9rRPyrgnUU6FcDvGepImjUC1sTHmjCFJrhbTWaBYtVt
        zX1A==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hYNd5YsYfzMFI2y1mvrC6tJ0qV6vjIz8/x7DMw=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cf5:5d00:7f6c:26b3:e573:28b8]
        by smtp.strato.de (RZmta 47.3.4 AUTH)
        with ESMTPSA id n07f3bwAAH0c1dT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 18:00:38 +0100 (CET)
Subject: Re: [PATCH v6 7/8] can-dev: introduce helpers to access Classical CAN
 DLC values
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org
References: <20201110101852.1973-1-socketcan@hartkopp.net>
 <20201110101852.1973-8-socketcan@hartkopp.net>
 <57350d3f-f8e7-ea2b-5071-be5b3347f631@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b12f08de-f5a6-2998-4e60-cc6ec107c6a7@hartkopp.net>
Date:   Tue, 10 Nov 2020 18:00:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <57350d3f-f8e7-ea2b-5071-be5b3347f631@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.11.20 16:50, Marc Kleine-Budde wrote:
> On 11/10/20 11:18 AM, Oliver Hartkopp wrote:


> I still think, that can_frame_set_cc_len() makes more sense. See my just posted
> patches for illustration.
> 

Yep. Your patches look fine!

Just remove my patches 7 & 8 and apply your suggestions instead.

Many thanks,
Oliver
