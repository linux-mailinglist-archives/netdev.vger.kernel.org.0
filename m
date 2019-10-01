Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25EA7C40EE
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfJATTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:19:33 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:34693 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfJATTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:19:32 -0400
Received: by mail-io1-f44.google.com with SMTP id q1so51019584ion.1;
        Tue, 01 Oct 2019 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2BaLCezQLev8M8DzOB2FSQ19vepy3ctiutA7BBjOd+k=;
        b=GarAMzAkgYn51/m8L4/o74U9F0HnRKFSuqAkVVKC0xLBgAzd1J74+ZQQLk5IZfxeCT
         Qhf0Q5HIwpcYcEMZm/xWKnrWssM0mlPa2KgWVCqClhYHha05+hSVd3zu12IPeOycu+S0
         lB9pOYntqSTEO57Me1spb4E0iBI8GsdGzpBsJ4tIvFbJK2lcdEY7+yBxSSgnQTb5uW/Z
         TsM//oSVJ6LUBkOeVOQV00p/8oz44CqGdRljVCnLsJbHJg3DGoewOAnS1MFhtBdBkddT
         TUa9yAQNOuRoCtSGjbHk3F1NVmGpKCHFcrIl3Mom0vWV/GNVvCqR6Sta1eb608vyp5V4
         EFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2BaLCezQLev8M8DzOB2FSQ19vepy3ctiutA7BBjOd+k=;
        b=EsJCO1Ga7Pk2cbTecK+/HFlV224MpVj76gMdjdvHkNeRjdUxrFe0ZPDJlRj4/+xy0O
         WKjlsziaTLLl6kjQRj0jfPBU+NequWkeydtnElQMtKKHa5bQ3YpQDB60h/rtRztIN9JA
         8rqybFlrtPXaCujn17mrqaEHX9xGacFMbaOG4uGWwHeCMHBUHXWaho8CMK1WTEmGJig1
         t1IewACOZWg93bkcKohN/f9UkCeAfffukTnd6xGx8annYAUm0sG/PBoObuoDhmGl2wRa
         cXxxUg4i9rX+s3qODigLzyjqpoC+9QWJzw/OPdqSZGUC9ihnPf77FV2xm/+Hjh98qe02
         9+1Q==
X-Gm-Message-State: APjAAAV/39sSww0vjbgnevaSWjRpX9lmX2WYUmfv8ykkBZQG6Him9rtw
        EYBq4QpN/HHXYNZMVpcMX4Y=
X-Google-Smtp-Source: APXvYqxoOdFkXY43KPe4Cj2xOAIC9+ajy02FlCLcOazVR111Wp7KcvsqLJtlVCH1kkPiMmvsNM3ldg==
X-Received: by 2002:a5d:9349:: with SMTP id i9mr896794ioo.101.1569957570608;
        Tue, 01 Oct 2019 12:19:30 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a14sm7104796ioo.85.2019.10.01.12.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:19:29 -0700 (PDT)
Date:   Tue, 01 Oct 2019 12:19:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d93a6b96a6ef_85b2b0fc76de5b4a3@john-XPS-13-9370.notmuch>
In-Reply-To: <20190930185855.4115372-7-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-7-andriin@fb.com>
Subject: RE: [PATCH bpf-next 6/6] selftests/bpf: add BPF_CORE_READ and
 BPF_CORE_READ_STR_INTO macro tests
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Validate BPF_CORE_READ correctness and handling of up to 9 levels of
> nestedness using cyclic task->(group_leader->)*->tgid chains.
> 
> Also add a test of maximum-dpeth BPF_CORE_READ_STR_INTO() macro.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
