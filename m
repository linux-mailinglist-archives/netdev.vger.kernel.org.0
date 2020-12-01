Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB642CA99A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404094AbgLAR0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:26:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389280AbgLAR0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 12:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606843523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k05XrRUyRgb4ANHasEbrn5SVTsL9xAA4UGlCC1/jfKA=;
        b=WSD2Isv6vWyIGp38nrPrmVrpHI3oW+i8jMsi4jhFz7VFGKqcKTFf3QNUJ497DJbJFnJmV5
        If+FLKFxuvxVqzmMN8hnaB43ojCjKDzPquTnBYJAKsWx6QjDqyTaO/7DTi2q27c5Wl1Qq9
        +mD+iW+TazxcHAe/41A3ZlvsKP9yiTw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-SyoStga3Pcyome4pHZFMJA-1; Tue, 01 Dec 2020 12:25:20 -0500
X-MC-Unique: SyoStga3Pcyome4pHZFMJA-1
Received: by mail-qt1-f197.google.com with SMTP id t17so1804761qtp.3
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 09:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=k05XrRUyRgb4ANHasEbrn5SVTsL9xAA4UGlCC1/jfKA=;
        b=avWXevLlIZpLNXec9vNpd3YrdbH3vDny8EPIYg/hi3c19xmFI8CdHaVQnVLENuOU/7
         pp69CFmLOkeCpse2QnvbOgWRjSuSVDmpOjfBdVgFTuPvgXYDh+NNOFixj3+eZ0goz9HD
         okypuezQPoAs7COrrfrdeDc7CFfe/TptIu7fZhl9e/a5AyqFKhIz8v87uJnzfOjnYQ5s
         shG/L49Y6xi8lMSITFk205Xx7HmyHPd6CY9MSpZjeCVy0CkpSjgShzR46FhsrORw9yXE
         URwQ36O0idTRkXlU2uoI8x1JD811h8SkMBjN/ZiFPcNGCxeDQvCtFefyrKQtC++P+wfZ
         yiqA==
X-Gm-Message-State: AOAM533bk7zbWGWcp+5I/4aOQTf0+lSfk9stJ//i42T01pqb97JUuSg1
        qWfEoX8g7W8EbyA1vOaR1PbxenNJfJB3uKJIR0965wZ0R4OxzqM2yA9GO4DshqCmj2t7Wwak1vE
        xfqmUEVidoetpSndP
X-Received: by 2002:a37:4c05:: with SMTP id z5mr4012773qka.245.1606843519621;
        Tue, 01 Dec 2020 09:25:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhSPlsDgJZASP/hR2Tmsk8orlVlQkFvTTuYSt1IPTQ9TzZpIK78QmtdBF92VH6pJ2vFxmxVQ==
X-Received: by 2002:a37:4c05:: with SMTP id z5mr4012743qka.245.1606843519374;
        Tue, 01 Dec 2020 09:25:19 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id l79sm282153qke.1.2020.12.01.09.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 09:25:18 -0800 (PST)
Subject: Re: [PATCH] net: bna: remove trailing semicolon in macro definition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     rmody@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201127165550.2693417-1-trix@redhat.com>
 <20201130190102.3220d9eb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <eb49f169-ff60-7a23-a461-f9fa012c0a34@redhat.com>
Date:   Tue, 1 Dec 2020 09:25:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201130190102.3220d9eb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/20 7:01 PM, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 08:55:50 -0800 trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> The macro use will already have a semicolon.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>  drivers/net/ethernet/brocade/bna/bna_hw_defs.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
>> index f335b7115c1b..4b19855017d7 100644
>> --- a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
>> +++ b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
>> @@ -218,7 +218,7 @@ do {									\
>>  
>>  /* Set the coalescing timer for the given ib */
>>  #define bna_ib_coalescing_timer_set(_i_dbell, _cls_timer)		\
>> -	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0));
>> +	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0))
>>  
>>  /* Acks 'events' # of events for a given ib while disabling interrupts */
>>  #define bna_ib_ack_disable_irq(_i_dbell, _events)			\
>> @@ -260,7 +260,7 @@ do {									\
>>  
>>  #define bna_txq_prod_indx_doorbell(_tcb)				\
>>  	(writel(BNA_DOORBELL_Q_PRD_IDX((_tcb)->producer_index), \
>> -		(_tcb)->q_dbell));
>> +		(_tcb)->q_dbell))
>>  
>>  #define bna_rxq_prod_indx_doorbell(_rcb)				\
>>  	(writel(BNA_DOORBELL_Q_PRD_IDX((_rcb)->producer_index), \
> Same story here as Daniel pointed out for the BPF patch.
>
> There are 2 macros right below here which also have a semicolon at the
> end. And these ones are used. So the patch appears to be pretty arbitrary.

I will add the other macros in the next revision.

Sorry,

Tom

>

