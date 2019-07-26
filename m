Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB67713E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbfGZSZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 14:25:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38608 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfGZSZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 14:25:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so24900541pfn.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 11:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ML7n5/KwF6EztDf3r1PlJyFHkCAa9EGXpyPfHbA/OD8=;
        b=yfbW6Pzmk25cAxiRzuCrfJtscEppV6RTY5GhTEz17nz0pvNQ7GkC4zW+uxbg07MCbv
         Z/184fk/w4hpnYDTacqIxpm5c0LLYPFAmY5HOKH80LW52Gf7zQ0pTkgAtqM1078mHxSc
         TynSEf5HRxe4xS06sy8NHaQ2mk/9w+lNlYgvpaITCZxA1kZteQ6uFbECogZJmA/zR9p+
         vGxec6JoPMXs3hTjVhwkPBEPr4sqLnhutSYRGfwAFgdveh0micW8Yd4V+9J7JhE6WvVs
         GhsIUo+9CQTeBHFaX2csW5y+cHYTBId47w3ZonMU5/DQwl3nyIWnpHc8FBa7Trxcx8AD
         fyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ML7n5/KwF6EztDf3r1PlJyFHkCAa9EGXpyPfHbA/OD8=;
        b=dDaB6FGwm6eMm3F0UX6j5u0IUhkVCLCp8wQsB947gEn189sYE1Dg7GN7YeehhzzE5p
         0XAvPvmiUEpu+y1h2EKS1aFueoqsNOw87e+qS+VrR6n8kiA0PO3cNwUYOFG9VJ5pggd4
         nIIcIztxV+0yMjQcTqKsMq7pWoCdSE0sT1e5nHrumVjY9iFXqiur92VawH7HibUGbhZu
         1WoQs8kazV1gYJvZyF99N354KwRoTTitvoA/rkoBZ4FV6FtbQn5145i4RAmUcBF7/JSy
         Q40byb3R/07Fd8FsW3pWkJQdbuPq501rdW+fiWQE3nmI2c36U4uU6SFF1pGRWMiZMA36
         JtaA==
X-Gm-Message-State: APjAAAUKhN9P7W02cPFxpf84WvRwzUPn63ZOcuhiAbRI5cjBSutiadu+
        FNfo3NoeAD6O9Gmh7zVdpM8=
X-Google-Smtp-Source: APXvYqwjq8obX16+Jb57/9GDyu/1B/IV8t0rCoedjQvo63l1twISPxY025IRFI/y2B8/ZMXR4b+HdA==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr99954471pjq.120.1564165521304;
        Fri, 26 Jul 2019 11:25:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 14sm52032996pfy.40.2019.07.26.11.25.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 11:25:21 -0700 (PDT)
Date:   Fri, 26 Jul 2019 11:25:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] iplink: document the 'link change' subcommand
Message-ID: <20190726112514.4b0f63e4@hermes.lan>
In-Reply-To: <20190724191218.11757-1-mcroce@redhat.com>
References: <20190724191218.11757-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jul 2019 21:12:18 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> ip link can set parameters both via the 'set' and 'change' keyword.
> In fact, 'change' is an alias for 'set'.
> Document this in the help and manpage.
> 
> Fixes: 1d93483985f0 ("iplink: use netlink for link configuration")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Probably just done originally for compatibility in some way with ip route.
Not sure if it really needs to be documented.
