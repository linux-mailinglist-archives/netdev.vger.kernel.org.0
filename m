Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9263037FCE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfFFVp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:45:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37091 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFFVp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:45:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id 20so2091517pgr.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYKqX1cnYQsUQg2Bfo9MumetZ7uF7DERt7J3r+3IDSA=;
        b=wWEIzVKxOg/ixWa9eCV97aojRVcc98uaj+jESzD9V05u/+JC6rBN0Nt/n/kIEUv+5S
         okgT7lMhv8Dtr0QRcPhR2+uw5rIVdb1D7213zzTo/MlEhx3fVvYBrpJ+wbZW0nruo969
         ig93AwJSX0h62/aGOBdrLzlk5viPu0zJcGftMclWTBNZiq1NNK1Hxe1+vOS2jP3lkKXH
         CxGXEAmVu58LTflSHjJLi465iUPMG3OK0xfZ5Jg7qnK13A3RLlS11p3BHFkhxEqg5sKw
         zZXHoPMGRRkE8pvLVKMFPicxokw8rPcR4yUlEyWFRlmsBPG3oxfhq3Tf+wlQOZvljrRw
         Oz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYKqX1cnYQsUQg2Bfo9MumetZ7uF7DERt7J3r+3IDSA=;
        b=Z7SO3YJyHunA4u1YLdngkg/aJpPlxB06Bg0Ra29Gm3dSzFVMr3mb37mlyVbxXZ6Ial
         83kDCLUtCAoDpJJahRgYthHumMG2bAj/N1wJWTaZTStI9mApnyTRKLKF0B2ChdE/nCF1
         S/j5hf45Z0qh+jwN6yqKVu1rIdMj8FksL3bUtKHyA1Rfk0rIxF99IGj1HFZ1Q/D/Yr0b
         t0+11z2a/afO5aGRFzoHH4kSUxyhf6xqnZLqKJJ48ockXpYGbm9VHZR4AijUR77tMwBa
         a4otc7ox/VA3neiRxF4RpaRAziQ6UeojPr3L1G3dQD+00Dp91jkX7CB+muYdi5tHBmdL
         GLgw==
X-Gm-Message-State: APjAAAXIH9s5WwVmH8nY/KVLboKVoCbIp/qofG7TgF3Sx4kdmq+yAsua
        f3zyXJNjFljPpArZil92tbHNDw==
X-Google-Smtp-Source: APXvYqwjqqHkanWZM6KUYXiHKnzQNwN/ezWoLo4eNtVB4T4ar59qjR8hjLaecuyeRQ3i+Cq+YXH3jQ==
X-Received: by 2002:aa7:8143:: with SMTP id d3mr51999319pfn.143.1559857526485;
        Thu, 06 Jun 2019 14:45:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 5sm101849pfh.109.2019.06.06.14.45.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 14:45:26 -0700 (PDT)
Date:   Thu, 6 Jun 2019 14:45:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Andrea Claudi <aclaudi@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v2] tc: simple: don't hardcode the control
 action
Message-ID: <20190606144524.40e92046@hermes.lan>
In-Reply-To: <ea2fbb2d36828188d11090d73b648d97988cdcf6.1559687259.git.dcaratti@redhat.com>
References: <ea2fbb2d36828188d11090d73b648d97988cdcf6.1559687259.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 00:30:16 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> the following TDC test case:
> 
>  b776 - Replace simple action with invalid goto chain control
> 
> checks if the kernel correctly validates the 'goto chain' control action,
> when it is specified in 'act_simple' rules. The test systematically fails
> because the control action is hardcoded in parse_simple(), i.e. it is not
> parsed by command line arguments, so its value is constantly TC_ACT_PIPE.
> Because of that, the following command:
> 
>  # tc action add action simple sdata "test" drop index 7
> 
> installs an 'act_simple' rule that never drops packets, and whose 'index'
> is the first IDR available, plus an 'act_gact' rule with 'index' equal to
> 7, that drops packets.
> 
> Use parse_action_control_dflt(), like we did on many other TC actions, to
> make the control action configurable also with 'act_simple'. The expected
> results of test b776 are summarized below:
> 
>  iproute2
>    v       kernel->| 5.1-rc2 (and previous)  | 5.1-rc3 (and subsequent)
>  ------------------+-------------------------+-------------------------
>  5.1.0             | FAIL (bad IDR)          | FAIL (bad IDR)
>  5.1.0(patched)    | FAIL (no rule/bad sdata)| PASS
> 
> Changes since v1:
>  - reword commit message, thanks Stephen Hemminger
> 
> Fixes: 087f46ee4ebd ("tc: introduce simple action")
> CC: Andrea Claudi <aclaudi@redhat.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thanks
