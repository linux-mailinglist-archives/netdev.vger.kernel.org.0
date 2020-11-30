Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193822C8F36
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgK3Uae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:30:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728959AbgK3Uae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606768148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEMeF3AMNMcYI65aSQplkoFbo+sAWz3Tjmr7jvdlwP0=;
        b=HQ1U3wXJpC1ZsECPbpOO5YzOIcvBHiSHPI9e0mS5QrafNthO01EWk3HU13l7c++YmWdTqB
        wi7Pb0JKepjA2S07WVmTBJYc9BvQ7khp+yUtDheNI86+6aQ32ZTxSu6KK8Td7usvEt0lwo
        th3ZOiOS2+uRAXgTGpc4BhHUIggf/Og=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-qyX_XS9kOCy5UtlxZAojuQ-1; Mon, 30 Nov 2020 15:29:06 -0500
X-MC-Unique: qyX_XS9kOCy5UtlxZAojuQ-1
Received: by mail-ed1-f71.google.com with SMTP id z20so4910418edl.21
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:29:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dEMeF3AMNMcYI65aSQplkoFbo+sAWz3Tjmr7jvdlwP0=;
        b=BDWB94ZLN8d0vrcVuXzHKhl9EiVde/ahQbw0/TrSW2vt4meA2FCZnVq/iOirp51Fe2
         Qs61ZSGAOk3ku72p8NrxvUHDGi9OMEBYmFqdsZzIwjUh49DYiib9xtxhHewr7C+m2Gb2
         Do1cfQHg7wB7uf9wgVYdlBxFZ7TvCu+vRmlD1vVjdsbhZXWgn+pf+DrMn+neuE4Ux9ZW
         epJghi6DV2eHlDSdii/g8t2WKWT6JgnDr+JnPz8k/x+fHrkxgXU7nMS94EXqp+aKFWoR
         Iilp61bHiUkCcGZNi1J9/NOxvPwrgnW4OJvQ1wMppDjcrCKWisWDCSQQ8UTzkFmmTOYL
         8DRA==
X-Gm-Message-State: AOAM531mMZgSd3KoWOF1w40hmAsY9gUNAf9ZEGyT0uPxW7ut1he26jsE
        X6MJiWvvJPJ6r9d4qNE3eSwEwY6PpebeSrnTk/oHTpazlvbW/wCYzcJIFDXAP2jqMaUYJY29KI5
        U9yJcCm1uGCfteWOxhWKQW33BshV7SDiizLtnkW3KRtT8HXW7By+fsVIIdn0cjIdmwy4D
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr11170017edb.107.1606768144734;
        Mon, 30 Nov 2020 12:29:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg9IglFIMQ0ZSm6k1KLj+p3mu5WZxF5QG0J+89nlaTxpR4umWpnoGsGHhv67ElcSjdL8GU8g==
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr11169987edb.107.1606768144486;
        Mon, 30 Nov 2020 12:29:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a13sm2400959edb.76.2020.11.30.12.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 12:29:03 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Mike Christie <michael.christie@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
Date:   Mon, 30 Nov 2020 21:29:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/20 20:44, Mike Christie wrote:
> I have never seen a public/open-source vhost-scsi testsuite.
> 
> For patch 23 (the one that adds the lun reset support which is built on
> patch 22), we can't add it to stable right now if you wanted to, because
> it has a bug in it. Michael T, sent the fix:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=b4fffc177fad3c99ee049611a508ca9561bb6871
> 
> to Linus today.

Ok, so at least it was only a close call and anyway not for something 
that most people would be running on their machines.  But it still seems 
to me that the state of CI in Linux is abysmal compared to what is 
needed to arbitrarily(*) pick up patches and commit them to "stable" trees.

Paolo

(*) A ML bot is an arbitrary choice as far as we are concerned since we 
cannot know how it makes a decision.

