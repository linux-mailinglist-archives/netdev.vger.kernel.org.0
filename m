Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF0231956
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG2GMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgG2GMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:12:39 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD50220825;
        Wed, 29 Jul 2020 06:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596003159;
        bh=PY76zfm+kzGW3ln7m/EBXIarw9yL5t13A+YBYaRZnHY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uqopkGcyM4VboI+tCVVrknNY0zJFxZxbrKoQO6c62ZVlVWy5PHDDS3dlI4Wq2labz
         fLkU9DX3sT/3oAeAjlXypWqfEdaVYRiI4FvG3LT293GvvP6YWAGZV2TN3zFXA/+rs6
         FXMZfxvaLgICXNA4jcc6awLurHSCln8xvtbJp740=
Received: by mail-lf1-f53.google.com with SMTP id k13so12372844lfo.0;
        Tue, 28 Jul 2020 23:12:38 -0700 (PDT)
X-Gm-Message-State: AOAM533rka6Owoq4qEuD6aZxWkpdJdTmc7aHFIVYv8NYRD58vuyw1tUw
        7A1xv/dALvlyvwJwzeVbARp4ESknv13XiBjDskE=
X-Google-Smtp-Source: ABdhPJyU2o3DWF4Tc79pmaYf1WlCsAy16y0jTNcNR/oT9I4arogxdeNg06rv/CJeTBF+U3dLeuwaAtAzIE7yDJiBWHU=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr15991952lfr.69.1596003157104;
 Tue, 28 Jul 2020 23:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200729003104.1280813-1-sdf@google.com> <20200729003104.1280813-2-sdf@google.com>
In-Reply-To: <20200729003104.1280813-2-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Jul 2020 23:12:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4UD1+0bZiabAqiZQns_6ahGmhvMfovte_JQKHotVb5Kw@mail.gmail.com>
Message-ID: <CAPhsuW4UD1+0bZiabAqiZQns_6ahGmhvMfovte_JQKHotVb5Kw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify socket storage in cgroup/sock_{create,release}
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 5:31 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Augment udp_limit test to set and verify socket storage value.
> That should be enough to exercise the changes from the previous
> patch.
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>
