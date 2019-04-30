Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0801016F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 23:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfD3VJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 17:09:13 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:56105 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3VJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 17:09:12 -0400
Received: by mail-it1-f194.google.com with SMTP id w130so7105373itc.5;
        Tue, 30 Apr 2019 14:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ITL6GnT99iTuUo4Gdedb1bi9GrcOFJPHYObyAk9BMd8=;
        b=djZHjEeYodY4Inw9mE/+qwEGtnUuoDQ7X5IRYYkR37RYt0U89Pe6A8m7lxb2LZQT3f
         HySDagSpxgvhuqpOqU8fteP15QbvJwiKMTXS+1UMX8I2OMU0CYO0EtsnnF9zePia8CHk
         lQeJ51FIo1QNfRWHR+Iw04/B8t4pcIDeOFGCJi1Y8Afn1PqRFk7cLPwazbya9N2TipOe
         x8nekJI6VNa+aBjunn4tzxsS6zynYwneqzMMN5nYVevwFOLH+75emn/+YwNDooQ1ybrl
         nuQ4VZg48WPuLhea2Xcbqrzc2+2MWaUhzl2OUctMVBItSRC+D5zwHzj+m2pLlO6MPTsC
         H0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ITL6GnT99iTuUo4Gdedb1bi9GrcOFJPHYObyAk9BMd8=;
        b=M+3smg6lU7Krwz9olOofVZv611yXkecxexKUyOvONiYTj7M4w0VXJ0N69Fn9eT07fd
         GRDvSwx2Td35OzUkrawYvs6cUva2COvDqhmQbw/KKXNwHfrZVQCty5sx/df02BfV26mZ
         QiwF9HtqaVLSx8N414wKqybUAUeGjrzQdFVZhBQZ0/eOyL8PUPViOgIGtA5gIVut+ml3
         qiuPD6mfaEgs062oMO4WYUQZm7YllpvNF3pEV2wGKRKkqklVML6tOEf8MtM2MBB6oW0k
         N8H52BHDuTcs6ZVxIiIHnh9Dqxmg/ZK75+0chi+XVYRkHa+pskx3khg8zz6Oa8ooj1de
         GCXg==
X-Gm-Message-State: APjAAAWEpUJ6hyOERZ4yvFhlzfaNHmiF736fkstPZtXjwgScKU/1yJON
        qgCkK6dRyoQ3D7lo7ApmU+pE9Yvh4AIJcEj79uw=
X-Google-Smtp-Source: APXvYqxL6M44SolsfpDx7Lr9lFvqtJGxgo3WuBhk4Pb8MaK4OA37LMOrV8YceigR2E6xOYrW6YKGf+/Zeyej87BtwNA=
X-Received: by 2002:a02:828c:: with SMTP id t12mr48268825jag.18.1556658551668;
 Tue, 30 Apr 2019 14:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162501.13256-1-mrostecki@opensuse.org> <20190430172701.jegv3tmcvo3ytdri@workstation>
In-Reply-To: <20190430172701.jegv3tmcvo3ytdri@workstation>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 30 Apr 2019 14:08:35 -0700
Message-ID: <CAH3MdRUuK7nuT=OG+68WLiq1ne8nY0x6WVYGDv_xsvZNNd58sQ@mail.gmail.com>
Subject: Re: [PATCH] bpf, libbpf: Add .so files to gitignore
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:28 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> I forgot to add "bpf-next" to the subject prefix, sorry!

Maybe you can submit a v2 of this patch with my ack below so the patch
can be easily applied without tweaking?
Acked-by: Yonghong Song <yhs@fb.com>
