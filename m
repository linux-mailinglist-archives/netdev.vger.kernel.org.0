Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072C4265608
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 02:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgIKAbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 20:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgIKAbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 20:31:01 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CE9C061573;
        Thu, 10 Sep 2020 17:31:00 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k25so10543900ljk.0;
        Thu, 10 Sep 2020 17:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0412DC0gQCVcXT+eeBHfu/FCDxETiEv+yph20SP+sE=;
        b=AEei3ItF+8C6FfG+sVweFwNxLYTOZ/xn0oiVVTB7u6LY9fhlk6ZjjoNEgOAPugQQ9h
         CFOsKAQBCLAluD9qJKCiIiknuCTx1kS+4Mht3J0NgfYSUrggYH3DksoGUiEi+aszJuTb
         U+qGbtLsrfqbon4JXSd101Bni+/PZwYGdPjJ6dQwVDFBFNXWsyTJ/b+vgKdHnCwQ68SM
         a1SRgACnS7dPEYY/3lL96O/sx2KazbJRt1/FDs0cXeoa8ldd+HCbocQuZlDqU0s+/Bjw
         F4GdQJMaxLWLrrRMIgD9ZmyGdK8+jZF3yLCve5ECq80AsWe6+SNzRbO/AQitw6VC5Pq1
         uVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0412DC0gQCVcXT+eeBHfu/FCDxETiEv+yph20SP+sE=;
        b=EsdZFhfzeDlv6sn+OYiwd6voqXntmb8kaf9o2oryUNyoswsdaxWfGFskuSVko+ZxB1
         bpffYP9md3ZN8B13fUP8v/spuJeLdThLBy2HY1gmZOSwbVMo6Ly2XXSn4UOeuQzYqoj7
         7FWZX7VYwIJDyqwxDeX8W5bdpaURGm5wxiDTHiBDlU5jWoBziOQGzV85KPxG83l7gcKu
         bF/NDks+M/e8D+TIEEsVL5h8p43NKKPVoN+Pfrb3TlHm/4Fo+KvbzO4GAvhcEtRfMrGW
         R+PKazM3wxzHevLUDTJAZX3F3iVTMChVQx9u7zbn13mwn29zp8RueIIGpp0qfpCZ/wzX
         JLfw==
X-Gm-Message-State: AOAM533ezgLyTvBezuQ+TehzSiYvoQsk6GwSL0ViI/+sNNYWCKOqNNgI
        +DURjcAHbtkI5jl3ZAr+g555s7BCzzWTwEX44N4=
X-Google-Smtp-Source: ABdhPJyzPyxp6XVgdVbKJ5ADP0AZmPtun87TSId/OrRh3h3cA2gUSJ6DqQwR6mOTPUvEIWOWYNQnOddAfNb3W83n2WE=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr5419511lji.290.1599784258709;
 Thu, 10 Sep 2020 17:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200910102652.10509-1-quentin@isovalent.com>
In-Reply-To: <20200910102652.10509-1-quentin@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 17:30:47 -0700
Message-ID: <CAADnVQL=7+owiok=-uH3HYjMiLGbq0bWnH_E2eBr8CrsQiLuUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] tools: bpftool: support creating outer maps
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 3:27 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> This series makes bpftool able to create outer maps (maps of types
> array-of-maps and hash-of-maps). This is done by passing the relevant
> inner_map_fd, which we do through a new command-line keyword.
>
> The first two patches also clean up the function related to dumping map
> elements.
>
> v3:
> - Add a check on errno being ENOENT before skipping outer map entry in
>   dumps.

Applied. Thanks
