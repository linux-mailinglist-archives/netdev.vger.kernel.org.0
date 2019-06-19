Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7897C4C161
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfFSTTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:19:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45830 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFSTTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:19:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so393915wre.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbGrC613Mx9I72tXYJMhbBLz41UWVEnBEWP2gav1xeQ=;
        b=aBXr1jsV1jbWttXEi3sHL8+qOgrX4SCK7Q3uVbbDXijKLs+hC8dMHeBclHmHaH6RMG
         60Sikq/JtAo1788WW1xNUDDiZXT7CZ+qVyBbd62Fo7/fAn6hFgwGegqGpeknn2dB0yUf
         7raHu/ONKbVQk+H9+fbOslfRAmfjkRsXWfKXkSytn2bBymBdjum5F8wEKkLXmPQi/YQM
         X0KZqYHQsxRt94MBnne1YpVayCpgxK6N7chjzpeIKRdiV9Kzb1QXNtmpkTK7VxHX06lB
         vaupuO9MA/NB0v/5tqVim2rAsJLyLDTKP1nJgwUtNCvVZKExW9sGtS8PKkfr5P6s6WYe
         pqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbGrC613Mx9I72tXYJMhbBLz41UWVEnBEWP2gav1xeQ=;
        b=DBL01OA1YjjCJrHwf4D9pkyhKZxLFtx+vnhZmuglZb8vKc5Y0fqj3RpeBbwX3SNVEX
         M6e1rr6+RqB6lnZnepxCohR4OBjDbb+R267byP5ix/gvaJduxTsuORs5Pa0+ND8aGoQn
         YJXVDHMwltjpPR1pFSRwenrTncSwBwr54FVZlFqzTUq8s3+KG9U4s9VOSNYkCbeAoAW8
         FDMK/QfC6WfkrF6kB2Uyo59fH1SOAlHeRhr541YGo2/pwAYvPXarvQ6SfiRIY6MYhD8A
         kYNDQBhbBcDzY8TErFVlKdwFXayT/1N6loBg0856b8EO+OTF2dupHz+ks8EhEAmlam2V
         bPyA==
X-Gm-Message-State: APjAAAU++dlKxFYZoNJxVISkNUNAEtrE1PJAbC0Mn8T0pTDrcWAc9f6T
        RK1ysoi4M6WV+w7KMbtSnbo8a/L7hranLWi69Gpy
X-Google-Smtp-Source: APXvYqzpL3l1WIqajnOtkCbtEf+ZBROZneTV4UfC6rTgSLtpIqrDjIMSBhzB2YWe0R2HLSHUurnOCdjUz96H3tPb7GI=
X-Received: by 2002:a5d:680d:: with SMTP id w13mr920295wru.141.1560971942128;
 Wed, 19 Jun 2019 12:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190619174556.21194-1-puranjay12@gmail.com>
In-Reply-To: <20190619174556.21194-1-puranjay12@gmail.com>
From:   Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed, 19 Jun 2019 14:18:49 -0500
Message-ID: <CAErSpo6SnVVufzTeChiM+k7YcNebPcmabKS5EQR-mP-HYz1aGw@mail.gmail.com>
Subject: Re: [PATCH] net: fddi: skfp: Include generic PCI definitions from pci_regs.h
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 12:46 PM Puranjay Mohan <puranjay12@gmail.com> wrote:
>
> Include the generic PCI definitions from include/uapi/linux/pci_regs.h
> change PCI_REV_ID to PCI_REVISION_ID to make it compatible with the
> generic define.
> This driver uses only one generic PCI define.

1) Start every sentence with a capital letter.

2) Use a period at the end of every sentence.

3) Use a blank line between paragraphs.  A short line (like "generic
define" above) *suggests* a new paragraph, but it's ambiguous, which
makes it hard to read.

4) This patch must build correctly by itself.  I didn't try it, but
I'm a little suspicious that including pci_regs.h will cause
redefinition of PCI_STATUS and other #defines that are the same
between pci_regs.h and skfbi.h.  You could either combine the two
patches, or make the first patch simply rename PCI_REV_ID to
PCI_REVISION_ID in skfbi.h and drvfbi.c  Then the second patch could
add the #include of pci_regs.h and remove the corresponding #defines
from skfbi.h.  Maybe a third patch would remove all the other unused
PCI_* definitions.  Arguably the second and third could be combined.
But it's much easier for a maintainer to squash patches together than
to split them apart, so err on the side of splitting them up.

> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> ---
>  drivers/net/fddi/skfp/drvfbi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
> index bdd5700e71fa..38f6d943385d 100644
> --- a/drivers/net/fddi/skfp/drvfbi.c
> +++ b/drivers/net/fddi/skfp/drvfbi.c
> @@ -20,6 +20,7 @@
>  #include "h/supern_2.h"
>  #include "h/skfbiinc.h"
>  #include <linux/bitrev.h>
> +#include <uapi/linux/pci_regs.h>
>
>  #ifndef        lint
>  static const char ID_sccs[] = "@(#)drvfbi.c    1.63 99/02/11 (C) SK " ;
> @@ -127,7 +128,7 @@ static void card_start(struct s_smc *smc)
>          *       at very first before any other initialization functions is
>          *       executed.
>          */
> -       rev_id = inp(PCI_C(PCI_REV_ID)) ;
> +       rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
>         if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
>                 smc->hw.hw_is_64bit = TRUE ;
>         } else {
> --
> 2.21.0
>
