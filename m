Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D489B35AC8
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfFELAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:00:18 -0400
Received: from hermes.domdv.de ([193.102.202.1]:1982 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfFELAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 07:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
        In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TjUiE4AlHaoi5rVRWH+eyVCURZH6sa/IT9QU5MfufHs=; b=XqfLez7BEJTACRhB2bLw7LnFeY
        +kj/P515xdhWIMD5qwMH3W+qfG1uZuAV8NLmH2vxBgLiLC5Av0ZiBkg9GP4bkNeAiNh9pXc7rgtNK
        QQYxqLRYuJFiiTi+HmK5CvUIzifwovK4Pe+QTjiyXtyJhytg4SCFD6TeiRMW089ztABY=;
Received: from [fd06:8443:81a1:74b0::212] (port=1718 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hYTeR-00033a-Ul; Wed, 05 Jun 2019 13:00:15 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hYTdl-0007Mo-OW; Wed, 05 Jun 2019 12:59:33 +0200
Message-ID: <f3b59d9ac00eec18bc62a75f2dd6dbba48da0b35.camel@domdv.de>
Subject: Re: [RFC][PATCH kernel_bpf] honor CAP_NET_ADMIN for BPF_PROG_LOAD
From:   Andreas Steinmetz <ast@domdv.de>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 05 Jun 2019 12:59:48 +0200
In-Reply-To: <1188fe85-d627-89d1-d56b-91011166f9c7@6wind.com>
References: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
         <1188fe85-d627-89d1-d56b-91011166f9c7@6wind.com>
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-03 at 19:12 +0200, Nicolas Dichtel wrote:
> It makes sense to me.
> Do you plan to submit it formally?
> 
> Looking a bit more at this topic, I see that most part of the bpf
> code uses
> capable(CAP_NET_ADMIN). I don't see why we cannot use
> ns_capable(CAP_NET_ADMIN).

If there is a change for this to get accepted, sure, I'm willing to
submit this formally (need some advice, though).

As for capable vs. ns_capable, this is a bit above my knowledge of
kernel internals.

Regards,
Andreas

