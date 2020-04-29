Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F91BE0CF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgD2OYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbgD2OYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:24:40 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F88C03C1AD;
        Wed, 29 Apr 2020 07:24:40 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i3so2342664ioo.13;
        Wed, 29 Apr 2020 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1CN4jZl4jTo+TBoqkD+2uQy2R8zmyg041lpKbHoH7M=;
        b=pTjVdU2l+wv4rjf7RjiT6n/blcv5kQhRkTpYCmloytxCdlJT0daN6v+k5wiAG5V05p
         +lyQmzwez7Vjd0dU1iU0E6Rw7gv7LqG1MW0U0Y8VRqwxCkoO6tKIPwR9r2MAefbYYF3B
         mFTuY85Kakd1ESJLf7sgADtBuP8ayxrkUtE7UfCTQ/8abnCI++kDFGUmYfVXPuFStAw8
         krNHekQgb2i+bDxKz/u6F0cAchKDkFph31Rl4hrAZW7Y5sov5rmfAJE/PJ4YSrK0H2Ne
         PRHZ7THNVQjRH38dM2RLvEKtAl48F3dlOW+bgCnko5NxLdm07f4BuONIRIi/iW+PnDN+
         AFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1CN4jZl4jTo+TBoqkD+2uQy2R8zmyg041lpKbHoH7M=;
        b=m/Jz6Bm3UffPAM4GsF/45veXKBDMSBp0hMBN3sV4hcoIIci2Ki6/i1c70zVka7BMu+
         Y57ita9TsyALb3IUS2G1wfagF+yNshJ2LRqUZDFgPS9OW/Me97Iy26641Unqwc8mIQP9
         ck6c29mpCsQCGaPfvcFYl3QM+RVgSQGrugxiHTIDnmeG4TuEIBBvgG7S7Ag/baAqxeiJ
         whZR4Acnx4c0WYJKC8QyesNjyCONHnpImRYtxJURB1sQnCHTt4Mm+uuESLkyXzIziv+x
         t4J4Zs+SI/698deXoobaiLpvgv2i7MEEFQy7bmySEWHEI3qPff5tyCB8PoLMGarLEYMv
         2ljg==
X-Gm-Message-State: AGi0PuasUZhMOkBtXBZuKwMP+AFVXzrZPUrPShUPzoVcoRuNj5daGrOA
        Jtoyd/BCBmB6EsK4yU2K7dkGea/kzLNK+eRclUY=
X-Google-Smtp-Source: APiQypL3YJRLn/CjDFWSkIcYSR70WFcO7nOnYCpUZp/Dvytozh01gIQHSjZZDOziBum8nxJbwwX/Hj3cpRG7hohBiiU=
X-Received: by 2002:a02:bb91:: with SMTP id g17mr29519507jan.88.1588170279522;
 Wed, 29 Apr 2020 07:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200428144314.24533-1-vaibhavgupta40@gmail.com> <d33991cc-c219-dc27-7559-f30dd5f4aa0a@gmail.com>
In-Reply-To: <d33991cc-c219-dc27-7559-f30dd5f4aa0a@gmail.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 29 Apr 2020 19:53:36 +0530
Message-ID: <CAPBsFfDn2GV8=o63zBRDhHddNnH+jUiiNCB+WRPUqH1mZasEPA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2 0/2] realtek ethernet : remove
 legacy power management callbacks.
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <mhabets@solarflare.com>, netdev@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 at 23:24, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 28.04.2020 16:43, Vaibhav Gupta wrote:
> > The purpose of this patch series is to remove legacy power management callbacks
> > from realtek ethernet drivers.
> >
> > The callbacks performing suspend() and resume() operations are still calling
> > pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
> > themselves, which is not recommended.
> >
> Did you test any of the changes? If not, then mention this at least.
> A typical comment in the commit message would be "compile-tested only".
Yeah its compile-tested only. I should have mention that. Thanks for
pointing it out.
>
> In addition the following should be changed.
> [Linux-kernel-mentees] [PATCH v2 0/2]
> Use
> [PATCH net-next v2 0/2]
> instead.
Sure!

--Vaibhav Gupta
>
> > The conversion requires the removal of the those function calls and change the
> > callback definition accordingly.
> >
> > Vaibhav Gupta (2):
> >   realtek/8139too: Remove Legacy Power Management
> >   realtek/8139cp: Remove Legacy Power Management
> >
> >  drivers/net/ethernet/realtek/8139cp.c  | 25 +++++++------------------
> >  drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
> >  2 files changed, 14 insertions(+), 37 deletions(-)
> >
>
