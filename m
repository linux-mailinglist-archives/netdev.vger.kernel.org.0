Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64CF17B163
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCEWZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:25:27 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36059 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgCEWZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 17:25:27 -0500
Received: by mail-pg1-f194.google.com with SMTP id d9so107136pgu.3;
        Thu, 05 Mar 2020 14:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uLTHblL9WJrI4bK/g8rOhHMekmLiYgOywSz4cT5UQRU=;
        b=s/DlhYrVQWhR3pqeK3ZpXSz3uX/GosdxK/lVBFc7VlPQ2epM5dZ/cwUkedOqiwRWo7
         KP2rNHKDcYAVxQggqvUs34/RI6i+DIGz0nJ4Ohr8F2fHeg/mj+KdT9hY1+Q4YqrL5n7P
         yze0MIoYRvJSyyJj+8jXcNxCm4dvrk1dhx3mKWCTHlaGA/WKfbsJiXFmI2+McjIfUu51
         5wzmRU7z8UEl4oAinIhU4CxPby+6Jc3RLbmjBian7vqkTKl7bY1tmk7uob6dyOLlRNa2
         4aj3oFA2xUKUGSEKBCJnVG6YefDT8kJg1LjNWBJ809gdthKxIcG9VVvJEY7YrzrixDM9
         SGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uLTHblL9WJrI4bK/g8rOhHMekmLiYgOywSz4cT5UQRU=;
        b=Mky4OmMeXAtjWs2oJE91VKigNDFva0tKhv8RmdphnDBGSmP4lvKEySXprikLMv6F0m
         k2CAkyhnu9oHsZ1CpTYDTDU+hRtyD6Ha3ZkyXcj9/36iH8s1kVs22vGBMTy7r1ZAvV7k
         jFLmp/gEwbrGFqQq/lcW3l3bq4XyjY7n1HEBGc+BOypf/FwXWO6jN64IYTDAFJyqm71j
         41NG26WTWV32bdzpI03/b8Wlo7Ysw/qmw25B8fgTDio6WuYJR/eLeWeQACFIu3c2gxiv
         Ul8jKDcFzLt2WtvpqInbeqZTn0ki9UWLpzHgeB4ZLiSp4UvHmoKNuLC1Tf60OUzzChqy
         zrBw==
X-Gm-Message-State: ANhLgQ1D7NEbN3T1o5ADg3RxDATiU3vBPgqT6sUF5M7811Xtw3RCtE7M
        sQJ5yQBu7HCOKGCci4heqgo=
X-Google-Smtp-Source: ADFU+vsLYW/QY/Jc2QvP+uFFKosot/16oSqLQ7d3NCNrvoGrr36EcFXRIZ4wPH54NL0WKzSDNrT4zA==
X-Received: by 2002:a63:c00a:: with SMTP id h10mr296608pgg.31.1583447126218;
        Thu, 05 Mar 2020 14:25:26 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f0e7])
        by smtp.gmail.com with ESMTPSA id d22sm7505334pja.14.2020.03.05.14.25.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 14:25:25 -0800 (PST)
Date:   Thu, 5 Mar 2020 14:25:23 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf 0/2] bpf: A few struct_ops fixes
Message-ID: <20200305222521.tscksbsxwuui6d7a@ast-mbp>
References: <20200305013437.534961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305013437.534961-1-kafai@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 05:34:37PM -0800, Martin KaFai Lau wrote:
> This set addresses a few struct_ops issues.
> Please see individual patch for details.

Applied to bpf tree without this cover letter, since it's too terse.
