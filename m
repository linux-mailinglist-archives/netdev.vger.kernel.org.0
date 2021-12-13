Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2B471FCE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 05:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhLMEJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 23:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhLMEJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 23:09:41 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA87C06173F;
        Sun, 12 Dec 2021 20:09:41 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id q25so21748644oiw.0;
        Sun, 12 Dec 2021 20:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OcFm7EDU7kcJ5TLVea2qKio04wWGWxfMRt4paeJKcKw=;
        b=SDR4+h+F6oLmKh8Wn2TA7yWoY39/pv6ZJtHcmvG3Ph1KbpBa/WqmJJkPhC80NzkFkA
         yYJodlUZEt2KRdeJyuQAGLku2NLl6CA2xwVbOOwHsnbJacL/v6Uj/NqQPhKW6xjUMFl0
         48Xp9ZNg7+H46+Zm9vbPwNnau6/VEnjJJhJTUc3zvQZ7j7lJ/t14D5qJgpoZf0Qf2EmH
         4SxYwFwGgjGB0VEPimRaKG6h76DbjqDCNAIOANlNldAEw9eOVsLrUJwi8AwP9lORgFu2
         QhO6SxX/qd0nuefqu6wdojJ4royNQ6UM3CuXSI8Cc1vbfw+O+uEtSCCv5bECsn2MSobY
         nlJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OcFm7EDU7kcJ5TLVea2qKio04wWGWxfMRt4paeJKcKw=;
        b=14KFLacD++XEuxcmbj+mFzHkJguwua6QqUK1oCC6Ypsj2Kx3TqyiTHoyWx3mvQdpMt
         T8njhiqfEJzlL8ILlrJRjresT/exA64xOQy1/D5uYdcQgoZOnCoiVum19al1u5rJIvsX
         iKy0agxPAYJvm0YWRL2FNQA6SwB6CuDMM3r244ASbiuEgssQGc6OKVeaIV4z1rWPzMO4
         qquqhyj/iI/UJLwd4I5MlDxSVFXgtqrheVugqO4gisftu988njHd4KV1jQ0oXYqN6y3K
         +/7Q96QVygfiy3t/ViCmExs/trzYBGEDTr+Ld0b7UfyojMAUmyl9y0bRlY/5iv8tHTmw
         aJ+w==
X-Gm-Message-State: AOAM532Ob3rEGslhvOvtZDCMAtrEYteV0dnM1Ia9YScKhJO6+dhK0nbC
        T8Ejzswq72ULdQBP0uOf5YV1zEs63NI=
X-Google-Smtp-Source: ABdhPJz7bnZ5O7hRDtTEQfz9RRNo0Er9qaJPo+wVXxZHwpCmfDxe/FpAm6lkGmYkKUooc/lH/fVZtw==
X-Received: by 2002:a05:6808:1285:: with SMTP id a5mr25343017oiw.104.1639368580909;
        Sun, 12 Dec 2021 20:09:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n6sm2013271otj.78.2021.12.12.20.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 20:09:40 -0800 (PST)
Message-ID: <65ca2349-5d11-93fb-d9d3-22ff87fe7533@gmail.com>
Date:   Sun, 12 Dec 2021 21:09:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v2] selftests: net: Correct case name
Content-Language: en-US
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Li, Philip" <philip.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
 <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
 <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/21 8:08 PM, Zhou, Jie2X wrote:
> hi,
> 
> I try to apply the "selftests: Fix raw socket bind tests with VRF" patch.
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0f108ae44520
> 
> And found that following changes.
> TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
> => TEST: Raw socket bind to local address - ns-A IP                              [FAIL]
> TEST: Raw socket bind to local address - VRF IP                               [FAIL]
> => TEST: Raw socket bind to local address - VRF IP                               [ OK ]
> 

After the last round of patches all tests but 2 pass with the 5.16.0-rc3
kernel (net-next based) and ubuntu 20.04 OS.

The 2 failures are due local pings and to bugs in 'ping' - it removes
the device bind by calling setsockopt with an "" arg.
