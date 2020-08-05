Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081A023C773
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHEIKj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Aug 2020 04:10:39 -0400
Received: from mail.mimuw.edu.pl ([193.0.96.6]:35517 "EHLO mail.mimuw.edu.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbgHEIJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 04:09:12 -0400
X-Greylist: delayed 80567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 04:09:11 EDT
Received: from localhost (localhost [127.0.0.1])
        by duch.mimuw.edu.pl (Postfix) with ESMTP id 876AC6016C1E0;
        Wed,  5 Aug 2020 10:08:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mimuw.edu.pl
Received: from duch.mimuw.edu.pl ([127.0.0.1])
        by localhost (mail.mimuw.edu.pl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4r_qm0RvNo3o; Wed,  5 Aug 2020 10:08:50 +0200 (CEST)
Received: from debian.mimuw.edu.pl (unknown [176.221.123.130])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by duch.mimuw.edu.pl (Postfix) with ESMTPSA;
        Wed,  5 Aug 2020 10:08:50 +0200 (CEST)
From:   jsbien@mimuw.edu.pl (Janusz S. =?utf-8?Q?Bie=C5=84?=)
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: The card speed limited to 100 Mb/s
In-Reply-To: <198814f6-ddc8-0be4-4df2-d255a133971a@gmail.com> (Heiner
        Kallweit's message of "Wed, 5 Aug 2020 08:16:43 +0200")
References: <86sgd2g2vo.fsf@mimuw.edu.pl> <86wo2eo05x.fsf@mimuw.edu.pl>
        <198814f6-ddc8-0be4-4df2-d255a133971a@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Reply-to: jsbien@mimuw.edu.pl
Date:   Wed, 05 Aug 2020 10:08:50 +0200
Message-ID: <86k0ydldkd.fsf@mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05 2020 at  8:16 +02, Heiner Kallweit wrote:
> On 04.08.2020 18:17, Janusz S. Bień wrote:
>> 
>> I apologize for a false alarm - the cable had to be replaced.
>> 
> It wouldn't have been a question for the kernel community anyway
> because it's about a out-of-tree vendor driver.
> And the 150MB/s - 300MB/s obviously refer to WiFi.

Jus for information, it was not Wi-Fi.

Regards

Janusz

-- 
             ,   
Janusz S. Bien
emeryt (emeritus)
https://sites.google.com/view/jsbien
