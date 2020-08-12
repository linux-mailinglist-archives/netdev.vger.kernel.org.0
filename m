Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210E624306A
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgHLVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:14:01 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA340C061383;
        Wed, 12 Aug 2020 14:14:01 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id 25so3163018oir.0;
        Wed, 12 Aug 2020 14:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=reyd1vwqqkrdy9zAyokM8csmESFkkcbB8ZgkgSPNKDo=;
        b=pv1hW/6iYpjj+bJbUU2CLIalE9pyu/RW3RXCByCY7GqeT5V+XHSIBD0EmzfT04x9pZ
         Hm4iH+1n28Z5+S+qZpyOCszii6Ra+D1glAPRqW3c4oYPNrn6Z4Z09wll8kcjW5uAAbcf
         DLXfQlIhElgcJ+1UpvlwbS3fIdScBJRlVf09lyntwAMwL6uxAP4xvwJm1tFM+N9LPJPx
         PqkFpFL+Fa5D7wZGsWhAtB6Y+TqzxSNXYJ+9eD/Sa+Ae4jIMSY9iI4gU2ZIxSgcCwMOT
         fLNAg929fXM5PM9HxPRihfPeEMqHSioF/WDix27tRjS4YPnroAsH7wz7PLdPhyi4SbfV
         EvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=reyd1vwqqkrdy9zAyokM8csmESFkkcbB8ZgkgSPNKDo=;
        b=fb1eRYtXoF/okyQczgvSDGzvRDlpPMS2RirHkAbe8XZkOQWklhHwN222RbauG0WEEs
         F4/tnx0sXBYMJYjgD9Puk8wodYGhjxlhUiEebHec7r068ltG38rDGm70rVtDKuMNnBMF
         VR+c6OvP5Z9Hc+vFiyYK4Cc7Uu+szBkGAZ23x8IrZM+lt33XginpFFeSxDX6dR+01cGl
         zxJ16WI41qUBlyBez9MQG1FQNkeoV++tbJzBPh8bhTPToksusoJ4NGGwcwL3NiNPyxCV
         3aUrbMKZcXJ8hk9bbn/RXNWHTByoPZhPd+oZwjx3+tHZ18YQg1ZcOGdkSNfZISHCKAII
         lUPA==
X-Gm-Message-State: AOAM531ipV/Wh1TZo7/93TB1BD5FGtPkxzRPmg/aeEzezSO9fLTz3dIi
        qBHHvCwF+bn6iDwQ/OonwvY=
X-Google-Smtp-Source: ABdhPJzx/uSz6TcNEGENiqPatkGerpxhDXYOuqc4Wf65lCKXbsV97NKqjp4sUXUXat6CkafBhZ+1RA==
X-Received: by 2002:a05:6808:610:: with SMTP id y16mr909433oih.0.1597266840556;
        Wed, 12 Aug 2020 14:14:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c1d8:5dca:975d:16e])
        by smtp.googlemail.com with ESMTPSA id y66sm675085otb.37.2020.08.12.14.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 14:13:59 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
To:     "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "hawk@kernel.org" <hawk@kernel.org>
Cc:     "Herbert, Tom" <tom.herbert@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
References: <20200810182841.10953-1-harshitha.ramamurthy@intel.com>
 <bf183ea6-7b68-3416-2a61-9d3bbf084230@gmail.com>
 <MW3PR11MB45220E877ED544FEBC1FF01885450@MW3PR11MB4522.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ca36641c-8360-c2d5-7cde-f4c7d933520a@gmail.com>
Date:   Wed, 12 Aug 2020 15:13:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB45220E877ED544FEBC1FF01885450@MW3PR11MB4522.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 3:55 PM, Ramamurthy, Harshitha wrote:
> is a pre-cursor to potentially calling the in-kernel flow dissector from
> a helper function.
> 

That is going to be a challenge to do in a way that does not impact the
kernel's ability to change as needed, and I suspect it will be much
slower than doing in ebpf. Modular ebpf code that can be adapted to use
cases is going to be more appropriate for XDP for example.
