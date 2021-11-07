Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7044758A
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 21:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhKGUJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 15:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhKGUJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 15:09:04 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF23EC061767;
        Sun,  7 Nov 2021 12:06:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id p17so13353916pgj.2;
        Sun, 07 Nov 2021 12:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OekpLS6n0vfyXW9EiXZ3yMHnlcE7KWkVPkEtc2FOOvQ=;
        b=EDvSovPR220oTJ3LN48OCJU4eE89OZf7PjeFjIdWCgPSq+h6NQzU6t3+9aKvzdOk7P
         tPyrviIF/TOniEAbHKhA2w6TlT019ADeHGmPFTsCxKlcYqqD9O9YDd2ThaB1mUnGZYwq
         kv9NJwhJSOC542g/xGA12V0z4G3iirH+f/IOMX33lkCF/+h16ZxqcngfbH5ybEEgP4v1
         Rn403vNes9vMlOPHPws0wDKUI+1R+AYBqFOYZn8+KvHkj50WgcCyzVGsayPPGWkYAsbh
         DpJFonPeC5xpPFi5jiRiIkjNsOJHq796Dvav2GmaVA38yZ8CFNyeO+gtW20gJSIf1rIe
         tyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OekpLS6n0vfyXW9EiXZ3yMHnlcE7KWkVPkEtc2FOOvQ=;
        b=VA3FJeCV7ak5NAOOFUHnpcbWQ9hkr3Oq+M1YBEhQ37WQ3r5QvDJdY/wLyQLlOwr/I4
         kLgAVyNjBHjsCfNO9cQ4tzitEEtuFWjYb56/vQ3isDuABYPzT6vpBHe7QvjiCmczDL6p
         OPStUtc357gS82orb1HDxjjLX9IvXy2G5uYDUOcb2MFqYuVyF1Wh1nRyFaLX4lhnRcn/
         WVITqXP4IU6tG6qjccgYVjqkLqtOveXaHr6q6c3NlweGmqCxxhvO676CXDPt3nm9oSBg
         zOCti/mX4ZCEbL36KOawnav3ihx/X7XtMwbNQOA2un+AcMmPyKpUeu204fiVw1SAeR3s
         wFHg==
X-Gm-Message-State: AOAM532E/zswl6Ypog732OhPjGbAsdA35Fgnt9tawgoI2ppoO9PjX1e/
        u8f4GkWVM5MckivKRPGbkyAJ+sq8Irxj3G0jlvU=
X-Google-Smtp-Source: ABdhPJx8MpmqT5vNOMyd1UWf+SlNwBcaZBLe5z3slFxjTGUVxzHFdAhp97jf0gh4srClKFxXIzGEAW73zsCtwpbSt9A=
X-Received: by 2002:a65:4008:: with SMTP id f8mr55988374pgp.310.1636315580309;
 Sun, 07 Nov 2021 12:06:20 -0800 (PST)
MIME-Version: 1.0
References: <20211105232330.1936330-1-songliubraving@fb.com>
In-Reply-To: <20211105232330.1936330-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 7 Nov 2021 12:06:09 -0800
Message-ID: <CAADnVQLomKBYUMucMLpOwYJ77-VxSAnBqAjT4N=XpqTx2z7d_A@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/2] introduce bpf_find_vma
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 4:23 PM Song Liu <songliubraving@fb.com> wrote:
>
> Changes v4 => v5:
> 1. Clean up and style change in 2/2. (Andrii)

Applied. Thanks
