Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35CA105874
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKURSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:18:38 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40513 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKURSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:18:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2so4117387ljg.7;
        Thu, 21 Nov 2019 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xN6nbu9DL5W8hgvBdkR7MXQdL0l/GpycEKoXFkz+Odg=;
        b=H2YJ3ICG1oQr0+rDhEh3v7q9fc+vMwT119tRsg1oFRuhLUEB3xGNE62PZYKB6+iLam
         lJf6CWbLPxOfKAvQP95NqjnMleeHuevFrl+AMz2zhk69DwAi9nIAOyTOBnzTvzz7I1Hi
         YW7+C3kVZ/uCWZQ+M6//Z1O48Umricm35bA08+xMdbGcKNL0Rt8sfdPLL7BFJUUHn4CI
         uajG2WOIhW7F9NRjGgAJmPbHAooR2Z0cSkAaAMVwQJXbcQtz/+JrhmlATf4mLk7AjH2r
         SBhN2Lb1aFs4JsHtAKVdk1Cj4CYyIrz7fQHKliIlAmoIkJ8lQM5LRZOyhxCTcpYC9xGy
         VTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xN6nbu9DL5W8hgvBdkR7MXQdL0l/GpycEKoXFkz+Odg=;
        b=gSHLL5AruWNUVkaCbbrOZwfpB2ULMa8qUw5uSL/KyDlYDHkmB71UWah5O61/mpyV3m
         0j9pC/8oOIBnJMs0roGjhim6Bcn1SeM+8omqlfvy+p0rJYJ4hMq5M6Sh3ZVWBWnjxUVA
         5+9kBnFlcUZ3LS8pClwy3lsun26ECBEa5nosW7VjCnjVJB9SXjRUe7GhD/2M88u28p8O
         WOrXQdHb7v3AYoUkBkD31aU/uR4UoQqyUskuG8JWbrYXR74T3dThJV6tYsGIo6SaDS2/
         AtZpQH/94foe8UIjyZKeNgU0zKLUC53QLQ8QmyyMLpH6BCAFf1yru50TpmJRFKVK5BHb
         6dIA==
X-Gm-Message-State: APjAAAU6zPf4zbDVJYDjiis7WlnLec6PCnIAQLqBADKdun6tKSvCyIku
        iCcOKCnfe2eGaQrEC4z6dkDhc3yqpqYelNj7/30=
X-Google-Smtp-Source: APXvYqzBs/CZZ9Ag7/TeD6ZlCw4t/k6QjEQ+ryJvqwSf6Se2GZEfp+Pa+e1aYqkoinnHVGbV7tUkq9trvdzMkAP3rCI=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr8630846ljj.243.1574356715361;
 Thu, 21 Nov 2019 09:18:35 -0800 (PST)
MIME-Version: 1.0
References: <20191121070743.1309473-1-andriin@fb.com>
In-Reply-To: <20191121070743.1309473-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 09:18:23 -0800
Message-ID: <CAADnVQLH2-HurZ3VAgtzmjrLCs9+1C9PaZ4=DNUofiJXV4grCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Support global variables
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:08 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set salvages all the non-extern-specific changes out of blocked
> externs patch set ([0]). In addition to small clean ups, it also refactors
> libbpf's handling of relocations and allows support for global (non-static)
> variables.

Applied. Thanks
