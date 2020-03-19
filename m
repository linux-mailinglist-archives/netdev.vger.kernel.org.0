Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2E18B95C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCSO3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:29:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36273 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgCSO3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:29:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id g62so2540442wme.1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 07:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IrdBTaTA8j+WmltTe957Iu/Y2q7jrjlS8Uzs+ESIox4=;
        b=Ccp89fgNRhSxgNemHfOHJNDtAxCTNyICmTMzFlDUIF0OENAQ+wBmvT1ZBJEeT4hpv1
         icWboGCJkgWjaL9lc4gKOhGUd6ZxKF7idxfBC2Tq09ZuIYLuCJuBhNPlkR4tsu3x1r53
         W7sTm/OFX+GwN68S305Jjtn/v/SRxsyoszN8h0tneChtJw817MmRqKzvKJt77fP6mdkE
         /n6s7razqi0+v8XKKtXGlYL+lKn0Vnlu9RDj2aFxbFxDv1sQ+v78gtoef1Nx6rhIs9p+
         PzEUsn6Q354MfxiKQ0TYzwhPydnP9OGPOUViZC50Xnw/nJ5qdvLiDFiHe7uswsIAozTj
         SlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IrdBTaTA8j+WmltTe957Iu/Y2q7jrjlS8Uzs+ESIox4=;
        b=JDXb8eNqE+w8tdvCydZMt+8FwF0+awSc8BEY4J2orL0lQ3djvAcFs57TWGeCPsKaui
         vN+9kv5/UdgaX+GzoQnh1YPjZag1nrZAYK6kMFKNUMVE2F99EWy4KVoOeqMHCsBn44jD
         XuY5GaB/5X66mRPlcsqJ51ixwrc/V2WdkPpObHjFc9MkVd/Bt02fwY/Qyg1oyWi8pet/
         EzQGDj8NDyvtK/0wV1Luevh5B6eJ5KY0tQ4gB7dyTrPB/R6v1bXzCTo4IpuMdKJz9Kvs
         SwxzESrW5lpVVpShYdj889BhQnZi/2fQVf8+BLJ/1P8vVgiqC7xf52PJmXBj4UzDcpx6
         F9WA==
X-Gm-Message-State: ANhLgQ23Pfu+FErygjhNqwn+JjDWUhQ4adaMBE+muj5bOSV7vsjdmsYU
        I2muC4LFw7NWyhiE/xZQp4fpLA==
X-Google-Smtp-Source: ADFU+vuNkC+R37sJKmfrvwQ89FPtRFcuFwW/i3+ZqwvaJfc37+VD6O5dJ5VjTSyukk7V/bcmkw8M+g==
X-Received: by 2002:a05:600c:618:: with SMTP id o24mr4295709wmm.128.1584628193363;
        Thu, 19 Mar 2020 07:29:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 128sm2300002wmc.0.2020.03.19.07.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:29:52 -0700 (PDT)
Date:   Thu, 19 Mar 2020 15:29:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        ecree@solarflare.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 1/2] net: rename flow_action_hw_stats_types* ->
 flow_action_hw_stats*
Message-ID: <20200319142951.GC11304@nanopsycho.orion>
References: <20200317014212.3467451-1-kuba@kernel.org>
 <20200317014212.3467451-2-kuba@kernel.org>
 <20200318063356.GB11304@nanopsycho.orion>
 <20200318124220.4fec8aa4@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318124220.4fec8aa4@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 18, 2020 at 08:42:20PM CET, kuba@kernel.org wrote:
>On Wed, 18 Mar 2020 07:33:56 +0100 Jiri Pirko wrote:
>> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> >index efd8d47f6997..1e30b0d44b61 100644
>> >--- a/include/net/flow_offload.h
>> >+++ b/include/net/flow_offload.h
>> >@@ -163,19 +163,17 @@ enum flow_action_mangle_base {
>> > };
>> > 
>> > enum flow_action_hw_stats_type_bit {  
>> 
>> You should rename this enum.
>> 
>> 
>> >-	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT,
>> >-	FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT,
>> >+	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
>> >+	FLOW_ACTION_HW_STATS_DELAYED_BIT,
>> > };
>> > 
>> > enum flow_action_hw_stats_type {  
>> 
>> And this enum too.
>> Also, while at it I think you should also rename the uapi and rest of
>> the occurances to make things consistent.
>
>Do you want me to rename the variables and struct members, too?

Well, I think it would be for the best, so the names are consistent.


>
>I thought in there the _type is fine, given how they are used.
