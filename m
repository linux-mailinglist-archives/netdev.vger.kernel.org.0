Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3723417834D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgCCTpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:45:20 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34273 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgCCTpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:45:20 -0500
Received: by mail-pf1-f194.google.com with SMTP id y21so2015364pfp.1;
        Tue, 03 Mar 2020 11:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4X++qMe4so4vJxEDTf+MGfWcvBuscrLBXjxPTNju6ck=;
        b=Lbgtt2i/PhS+8hLjNvMVh1HpywfjiOTPV0Z0xmBmhU+5JHPGxCv8xjadR5nBgBq5jm
         RFmCOmLOFV75ETGNaLlDxt25hCwbzgnHKEjcM0/L1bAQpK6jLNH8FszA+sHIO0xuT9XD
         fr6a6zwXSonpvIUmXZC/S5Zmxz9EQZn7l6CUdwYCldLTr8kBMtTwb0M+EhyiWpdt5orx
         wL/irCcPGMDKy8uvTT5t9PAriaY0+Aa1bBrl72Lmwjxggmw21kzK11FBFHXUsBvPU3o/
         MX9j/Rj3P6o1/BoEgBQKl/r7gYTfg0U800hVSQBe2slCq8PlB0O+2z8qef10pmd3umZy
         7U4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4X++qMe4so4vJxEDTf+MGfWcvBuscrLBXjxPTNju6ck=;
        b=SJQ39m77iUKtRd/T/TT5IFNY1PHyl2n4zqu4Iv12e7o0JOrdX+pf/yhstFq8n/t/6+
         4L3VvDrR8QAEVMIjrae1nIYe4Asa7K8ibpJLTvj1hRG/Xd1uyH6T8MjRB9e5QCDaMd+f
         tU0bPCxfv2jHiOE+/7/mfzJwIdQFUxyfenMFzC0KUupoA9sra9gI9/DyRd5dWX0ytJRq
         9WtAj1T3Eutjig2MN7o2U5CDEKMrupkf75ZRO0WnuVZiKeY5g+aXoSnUjS0GbC3WiZCY
         dbraR2MnhrUu4SFXPYxsuBQxUAyBpQsh/m0LmsXH1VLv7zFYLjRaDgifn9nJC2ykXjp4
         MrTA==
X-Gm-Message-State: ANhLgQ3gr0oJR8vinItw+Gp4r6t2HyG10ISQKosd5ajP4R7ar/0l4Lvj
        /YtFazPf7ansgF/IvJcDSht3CfST
X-Google-Smtp-Source: ADFU+vsqCtRnPJbDe5j0cZu6Bj4qwSR25RjpNBeBU3fe+jGQ0D52cUo10BDmfyWPKvIsY152JRC3Lw==
X-Received: by 2002:a63:7e1c:: with SMTP id z28mr5591268pgc.105.1583264718907;
        Tue, 03 Mar 2020 11:45:18 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x19sm1267433pfc.144.2020.03.03.11.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 11:45:18 -0800 (PST)
Date:   Tue, 03 Mar 2020 11:45:10 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e5eb3c64247c_60e72b06ba14c5bc2e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200228115344.17742-10-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-10-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 9/9] bpf, doc: update maintainers for L7 BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Add Jakub and myself as maintainers for sockmap related code.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 495ba52038ad..8517965adde8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9351,6 +9351,8 @@ F:	include/net/l3mdev.h
>  L7 BPF FRAMEWORK
>  M:	John Fastabend <john.fastabend@gmail.com>
>  M:	Daniel Borkmann <daniel@iogearbox.net>
> +M:	Jakub Sitnicki <jakub@cloudflare.com>
> +M:	Lorenz Bauer <lmb@cloudflare.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Maintained
> -- 
> 2.20.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
