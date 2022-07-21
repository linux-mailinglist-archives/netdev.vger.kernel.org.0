Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D36E57CD22
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiGUOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiGUOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:15:46 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB7AE51
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:15:44 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-10c0119dd16so2555063fac.6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=do6FpxeLRuIHGH0TIXGRYODgLCn8/O+9CM9EGnbvBKE=;
        b=cag7ylSOvf1ugWUUfvEj7cPATj3y5JXKvAqwexhx6B99Uo3DQyzD1+yddwoYvkZKvn
         H9xDK98jfg+l8viv2vzxgCYzIeQa7fRgQQ0z08Lz/bVfItsePS47AjTb3RXJsNfMi5Za
         5oJ4LI6tdTxNrXlpZk3ZFd36yT1U9VQQBjWQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=do6FpxeLRuIHGH0TIXGRYODgLCn8/O+9CM9EGnbvBKE=;
        b=FkkS9Ej5koQEBQC2BcCqViSCGiictt8CsPvlpzPVsQiNJIJAdrzwn1ruqYfpMXLwIL
         WUAGS3ccRo9yMJCTfQU8qJfMWI2WLClVPHACDiCdr7HiTNc1HfSEKHeZWNhMBj6LYCY0
         GLW4xVDert/XsLGiPVYILjodFlSMYQZQMEjZG4Iwzxy5HC0Yvfv/u4sL1we4oerJ8sdD
         sCoo+2rXRJ3QNzAI260miTSafqVVv2uY9HhRMDcKm29frdjqOtBHh7RDK1Uxn+cJrY5P
         zRBnx32s7bnNbraYG0Hf7XeVIN6v7y9SR2P5jvuSPxjniBG/PCSqtilhBHx9yOubzrQj
         oY0w==
X-Gm-Message-State: AJIora9NsF389PXYUxzFVFVLTvDBAxmJ5bia3BNGQdOSjSzrUvseD+h7
        OIaH6MPz+q43guO6hm7/ArrAJ8JSDwINNQ==
X-Google-Smtp-Source: AGRyM1sK0WgVZUyUOBm1kTNEBLRX5LFVBM9C2IlPtnl+e/zZQ5PtseKndqes1EFjp07qV3DMM0RiIA==
X-Received: by 2002:a05:6870:c1c1:b0:e6:84ac:4f86 with SMTP id i1-20020a056870c1c100b000e684ac4f86mr5535768oad.46.1658412943897;
        Thu, 21 Jul 2022 07:15:43 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u189-20020acaabc6000000b003263cf0f282sm662296oie.26.2022.07.21.07.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 07:15:43 -0700 (PDT)
Message-ID: <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
Date:   Thu, 21 Jul 2022 09:15:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: ipa: fix build
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alex Elder <elder@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 8:55 AM, Paolo Abeni wrote:
> After commit 2c7b9b936bdc ("net: ipa: move configuration data files
> into a subdirectory"), build of the ipa driver fails with the
> following error:
> 
> drivers/net/ipa/data/ipa_data-v3.1.c:9:10: fatal error: gsi.h: No such file or directory
> 
> After the mentioned commit, all the file included by the configuration
> are in the parent directory. Fix the issue updating the include path.
> 
> Fixes: 2c7b9b936bdc ("net: ipa: move configuration data files into a subdirectory")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Interesting...  This didn't happen for me.

Can you tell me more about your particular build environment
so I can try to reproduce it?  I haven't tested your fix yet
in my environment.

					-Alex

> ---
> Note: I could not use CFLAGS_* here, due to the relevant compilation
> unit name including a slash. Any better option more than welcome!
> ---
>   drivers/net/ipa/data/ipa_data-v3.1.c   | 8 ++++----
>   drivers/net/ipa/data/ipa_data-v3.5.1.c | 8 ++++----
>   drivers/net/ipa/data/ipa_data-v4.11.c  | 8 ++++----
>   drivers/net/ipa/data/ipa_data-v4.2.c   | 8 ++++----
>   drivers/net/ipa/data/ipa_data-v4.5.c   | 8 ++++----
>   drivers/net/ipa/data/ipa_data-v4.9.c   | 8 ++++----
>   6 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ipa/data/ipa_data-v3.1.c b/drivers/net/ipa/data/ipa_data-v3.1.c
> index 00f4e506e6e5..1c1895aea811 100644
> --- a/drivers/net/ipa/data/ipa_data-v3.1.c
> +++ b/drivers/net/ipa/data/ipa_data-v3.1.c
> @@ -6,10 +6,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.1 */
>   enum ipa_resource_type {
> diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
> index b7e32e87733e..58b708d2fc75 100644
> --- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
> +++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
> @@ -6,10 +6,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.5.1 */
>   enum ipa_resource_type {
> diff --git a/drivers/net/ipa/data/ipa_data-v4.11.c b/drivers/net/ipa/data/ipa_data-v4.11.c
> index 1be823e5c5c2..a204e439c23d 100644
> --- a/drivers/net/ipa/data/ipa_data-v4.11.c
> +++ b/drivers/net/ipa/data/ipa_data-v4.11.c
> @@ -4,10 +4,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.11 */
>   enum ipa_resource_type {
> diff --git a/drivers/net/ipa/data/ipa_data-v4.2.c b/drivers/net/ipa/data/ipa_data-v4.2.c
> index 683f1f91042f..04f574fe006f 100644
> --- a/drivers/net/ipa/data/ipa_data-v4.2.c
> +++ b/drivers/net/ipa/data/ipa_data-v4.2.c
> @@ -4,10 +4,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.2 */
>   enum ipa_resource_type {
> diff --git a/drivers/net/ipa/data/ipa_data-v4.5.c b/drivers/net/ipa/data/ipa_data-v4.5.c
> index 79398f286a9c..684239e71f46 100644
> --- a/drivers/net/ipa/data/ipa_data-v4.5.c
> +++ b/drivers/net/ipa/data/ipa_data-v4.5.c
> @@ -4,10 +4,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.5 */
>   enum ipa_resource_type {
> diff --git a/drivers/net/ipa/data/ipa_data-v4.9.c b/drivers/net/ipa/data/ipa_data-v4.9.c
> index 4b96efd05cf2..2333e15f9533 100644
> --- a/drivers/net/ipa/data/ipa_data-v4.9.c
> +++ b/drivers/net/ipa/data/ipa_data-v4.9.c
> @@ -4,10 +4,10 @@
>   
>   #include <linux/log2.h>
>   
> -#include "gsi.h"
> -#include "ipa_data.h"
> -#include "ipa_endpoint.h"
> -#include "ipa_mem.h"
> +#include "../gsi.h"
> +#include "../ipa_data.h"
> +#include "../ipa_endpoint.h"
> +#include "../ipa_mem.h"
>   
>   /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.9 */
>   enum ipa_resource_type {

