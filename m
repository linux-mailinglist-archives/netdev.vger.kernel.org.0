Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0164041937
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 02:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405983AbfFLAFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 20:05:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41495 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387864AbfFLAFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 20:05:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id s21so13434812lji.8;
        Tue, 11 Jun 2019 17:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twnhTVYd7tn35O7vvlIa3XEgKYk2/zieh7kgQ5Ms1VY=;
        b=iDBd+Nyh60vWHvSGtVHWVETugM2fnnm+FqmmiJZ56NZHl6V9Aty9AmjFW8CRdEnVVB
         aGKuXc3BMI1WRmMN59ZmT1r6kVO7qzb4q1bDpYmpS/ZUrVuenxbQGoF2Qv4WS5P5xTYu
         MgUGL2vvXlsZ04GvxKv4oWOnyz8mNGE24H+bdBFJTo0aHTJ0k0u+7bh9tcE9VNAMwAtH
         iKtxqCy1DSmKDdJUUU93WbsyygyX8RtwvZ5Owd5cCDJ9ZU6yAlx8+gKU6PDNIGy1Yrds
         5FOvUqOWwAWAd5bt0eEYz6DGK7Ot7sHrl6lNbuwYOmPXTEQ7T1WTuP7Qnyr0A/A07xpx
         QkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twnhTVYd7tn35O7vvlIa3XEgKYk2/zieh7kgQ5Ms1VY=;
        b=fqEU0XMyfNflfhQT79oxZghavXpJ1dAzYWSMm/qb4gmos8iA2TeNBJ0PUDAE/Hziuc
         bcmkQUVGTodSXW4WmUcE9UbCbklB1P7Hfg+uvtOj6dEzEdotDAAFyArOd3ScHgIQNVs5
         0JS9pIniFAgDhZ4tXvbDA5Wd7OJm5Til/+3lHBMc+FZ4Th9Uj7DK21wcJRIHCksoumid
         oyUuStSybwP7edfVFrdhM6JvHk+DDVpdY1QTx93zhasPNw8m+Rv31ORF54nq/akB0sbh
         SVkLKb03VXRyP+j7I9Yb4Iqiz7BHFYtNrpDNWePKx+aosKbJYg7P7LG1/Z8/MzWuKwy8
         Zlbw==
X-Gm-Message-State: APjAAAVdLDPQZSMGnTI0GPYm3j5E17tzyOWa4m4EfXM7tVCJe8oCX3/+
        qfJ4ROah2uLK8s8qnMM5gMeTz+fyeeBSbUV9JBw=
X-Google-Smtp-Source: APXvYqyO/Oi3PmoK5iJ0YzdPrMw5xZcqUF1R75rhMCOs6SLJy8NUkUXX4LUB1wFJr6ZxPQT0SJAlgxYZrwxAPMCixo8=
X-Received: by 2002:a2e:298a:: with SMTP id p10mr12710225ljp.74.1560297918252;
 Tue, 11 Jun 2019 17:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
In-Reply-To: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 11 Jun 2019 17:05:06 -0700
Message-ID: <CAADnVQKwvfuoyDEu+rB8=btOi33LdrUvk4EkQM86sDpDG61kew@mail.gmail.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
To:     Shyam Saini <shyam.saini@amarulasolutions.com>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Network Development <netdev@vger.kernel.org>,
        linux-ext4@vger.kernel.org, devel@lists.orangefs.org,
        linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org,
        mayhs11saini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 5:00 PM Shyam Saini
<shyam.saini@amarulasolutions.com> wrote:
>
> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
>
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h

please dont. bpf_util.h is a user space header.
Please leave it as-is.
