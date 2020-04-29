Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18521BE168
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD2Omt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgD2Omt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:42:49 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13542C03C1AD;
        Wed, 29 Apr 2020 07:42:49 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c18so2646272ile.5;
        Wed, 29 Apr 2020 07:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xqWtuuKGyccZnCAMErVogWBfiRD+U5fCxE5xiaJTzfo=;
        b=s5fCj4BQKrHN0Zovvg3Dr25wInQgTYs0QpmECbgHHuMzwOfZPpWBo5kbvDtkQXXTSO
         iXDdXHTqmTd7tdHb5K3vCr+nZ6G7qiXnMz078lmJjWeTAqZF5MjEb44MxQVO0aX+ljfQ
         /0c6q3bgMT7t0XSvGyJsfR0dnidb17q2HiJ7X5F/WbSn6W3ukIcAoSbUaOZYtqlc3dQH
         YmlE4eHfQ9RXtB4WmPRDsuiST3FZ4SuBpxQiy5IQK+wmr2PaJGMR1X1a2Nw1TqTFZmGH
         pHRm1Xf+CnOprzL8LoiY181dWiUMUTOuUF3P3A/0xGL0kIAw9FnTMlbxZxtEGza3Eq18
         Dh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqWtuuKGyccZnCAMErVogWBfiRD+U5fCxE5xiaJTzfo=;
        b=bBd5WPe/QloBcvOE6tHaZ6MOKoJ9kz/p/y40hmGGnGmXbW1VsWiq/3BIU2I7/VnU3h
         SpYMRlFW4+VCtcLQYOaC7BwdkXbpNBAgdtEDysrUdfw5bqZMH0kkni9rz3L868G37U3s
         jSDPMiDOLX7VKDvCd/AVeSrfiJTTcepuGwixHXld4ME63v60jNnoLj43RcYBEzaYTtgf
         Y8APIYJkyink4crTME5s41roKuTrqGG0sxTgX96W7HdZltjhDgShBVpLKe36rbXDB3Q5
         fDPoYyrukoLDHWq9xeKZPuceOQzy4oE5nwLUGTntXKto2ZI4lPXX8xvVRLgr6STDtUhA
         r03w==
X-Gm-Message-State: AGi0PuZWpI6COLbL+JwjXnpb6DlJw9mDTzkEfO9cvs6pEkxzKbVx6xSY
        C0wZ+9QyVPOuvWPaXFxjcImYpHlUkJN09PhE0RU=
X-Google-Smtp-Source: APiQypJ7U9Prko6Vi5K48lXkGdf0yeTY8OK5a8KU1GkGRlP47cvtBGWMdJwRF+dEj65ASvEvOa24knaqwchBPTLuB7o=
X-Received: by 2002:a92:cac7:: with SMTP id m7mr32641141ilq.6.1588171368312;
 Wed, 29 Apr 2020 07:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200428144314.24533-2-vaibhavgupta40@gmail.com>
 <20200428171928.GA170516@google.com> <CAPBsFfDjVSRHjf36WcAgteH9XocrmrNYTPW4fD2Rwi0neJF6ww@mail.gmail.com>
In-Reply-To: <CAPBsFfDjVSRHjf36WcAgteH9XocrmrNYTPW4fD2Rwi0neJF6ww@mail.gmail.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 29 Apr 2020 20:11:45 +0530
Message-ID: <CAPBsFfBtr12m1e9njtVct_V1RPSVYksuAdMjhgqUQ1WqFRLYsg@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2 1/2] realtek/8139too: Remove
 Legacy Power Management
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>, netdev@vger.kernel.org,
        bjorn@helgaas.com, linux-kernel-mentees@lists.linuxfoundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Uncapitalize "legacy power management" in subject.  I'd say "convert",
> > not "remove", to make it clear that the driver will still do power
> > management afterwards.
Sure!
> >
> > I think your to: and cc: list came from the get_maintainer.pl script,
yeah.
> > but you can trim it a bit by omitting people who have just made
> > occasional random fixups.  These drivers are really unmaintained, so
> > Dave M, netdev, Rafael, linux-pm, linux-pci, and maybe LKML are
> > probably enough.
I will keep this in mind next time.
> >
> > On Tue, Apr 28, 2020 at 08:13:13PM +0530, Vaibhav Gupta wrote:
> > > Upgrade power management from legacy to generic using dev_pm_ops.
> >
> > Instead of the paragraphs below, which cover the stuff that's fairly
> > obvious, I think it would be more useful to include hints about where
> > the things you removed will be done now.  That helps reviewers verify
> > that this doesn't break anything.  E.g.,
> >
> >   In the legacy PM model, drivers save and restore PCI state and set
> >   the device power state directly.  In the generic model, this is all
> >   done by the PCI core in .suspend_noirq() (pci_pm_suspend_noirq())
> >   and .resume_noirq() (pci_pm_resume_noirq()).
> >
> > This sort of thing could go in each commit log.  The cover letter
> > doesn't normally go in the commit log, so you have to assume it will
> > be lost.
 Okay. I will send v3 patch-series with changes. Thanks for
acknowledging :)

--Vaibhav Gupta
> >
> > > Remove "struct pci_driver.suspend" and "struct pci_driver.resume"
> > > bindings, and add "struct pci_driver.driver.pm" .
> > >
