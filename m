Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A569C89D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfHZFKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:10:19 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36611 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:10:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id d23so13174937qko.3;
        Sun, 25 Aug 2019 22:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqY7zhAN1IXexJ1fVM85HTQCVYN3FhNpLuHJeG2Lv8Y=;
        b=oZu459aGi8GsmerCQtGz+TNgn04Edp0D84/tZ8Z4qFJtYEbOaiMeiln5Dat2PW28uW
         ly2DG0LOhs2dQPPeCP7/0gcllHGirh3iqKjHEwgwRk0+2dE06Xdr+4XnQ1fNwUWrcYEu
         5qUI6bUHV4uMuANfqy6HTY4wPt98drJs9Qj72ZzY6UymcXKWmZUvNkJ5IJmU3j61VF9p
         g6KpUtPH9t8+gk6vOnTXWLxcviDvL+DDJqL3eHQFJNorysUIJdqz+XixRyY7YwJdgZFJ
         NJjgVVNGx8Zp8RZbH327QDjKBuE/D3F3qsEuqO/Cs9G0tey3In+i9HaGOGsUrqcGQW15
         EeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqY7zhAN1IXexJ1fVM85HTQCVYN3FhNpLuHJeG2Lv8Y=;
        b=EAi/pJaFfQheVWOnBxTBEDBrlb+5FeVrKckl93RYK4CZdf0MkFI/PwwnbpiQm+VMXI
         F2ftrclzgn22xmW8FB0SFVAcouvHIQwsAoD0iLAfZjDyUelh7QAK/2cZjOpc+mMS45Tz
         YQeECBCT9ty6CwxpeY/xlETCKWyydGsfqGujKcmErN7KLZYZQMdK0vynQ0U67W11Sq+O
         vU+7G3/im9MI1cbjouIrjMlfZCjayxTA4RRS1JagOC7ookdJ5d0H3S5cFVOXc1y5XawI
         rI8KOvjcx1PnyAQJGZe1WLr7k4PSAFLazzPP1zF3sTs7FC0X1StqvVvjwsog6FO3wDUB
         cTTw==
X-Gm-Message-State: APjAAAUdupcBLQJoQslHUvkxAq8Fhr799en/1qMa31m9kdBakF7iui5v
        BBpcxcQQEjHCg9tEek2gbdgAB2uyjgcVipErP+w=
X-Google-Smtp-Source: APXvYqxiPVRtJzcS3zEtxftI2K9A0vylUrXFP9MYpXZfAzPq4CNeeHzcv8gZaLiXAwQTiNvGjT3Fvsw5+5FYqGJxIPU=
X-Received: by 2002:ae9:e118:: with SMTP id g24mr14775889qkm.378.1566796218451;
 Sun, 25 Aug 2019 22:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190823055215.2658669-1-ast@kernel.org> <20190823055215.2658669-3-ast@kernel.org>
In-Reply-To: <20190823055215.2658669-3-ast@kernel.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sun, 25 Aug 2019 22:10:07 -0700
Message-ID: <CAPhsuW7inwnX0zDqzsYsY=sJqmQSYf7ju_eTj7Qh-A-LBa14tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] tools/bpf: sync bpf.h
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 2:59 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> sync bpf.h from kernel/ to tools/
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
