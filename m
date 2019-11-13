Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2423BF9F4F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKMAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:31:31 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:44909 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfKMAbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:31:31 -0500
Received: by mail-lj1-f178.google.com with SMTP id g3so464911ljl.11
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 16:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qBr61WvrznKUKg1XcI0ZEzBI3nOCXvjys9PZoBsmkmg=;
        b=OwB4pYv2OQ6NVUHyBD6ZCESC4YYq2Q0l1Xg0n1PPyaBXxs1SVcy2Uae4voZH7C3kKH
         jW5f4OHzGQVFVMSu/m5JnAMHs1S5Md1mynKUeMdUMTr4GSw+KZU7WhX+FhnMV4CpgGNo
         FxZam7cDBnc56My7BLUuY+ADMcqU/XQFzfCBot1BM+ct7qEXY043E7tadReWm+l3TX8u
         7r8I6mjwsQxkOWsz48JZiBhwUW+R9ebzgucpEVkvXPlOk9o5IBmO4VJ8NS/yhh3CZd3Z
         C9stNedwKKdxwRuHRM9sCc6smcPJ3/jOeQlCHDaxbs+3EDLo32NoKHRDutap+XS4hJoo
         QGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qBr61WvrznKUKg1XcI0ZEzBI3nOCXvjys9PZoBsmkmg=;
        b=q8uoQT+6lMPFPLM8bScLuf8bpD7AdFf30ZBshKPpJMRwBftRsoEMVxwtUjTAnLEL5r
         +KaIGtSB9evChSQovavXyoReqSq+7bW0ieSawDIWF9YqNbWCiWrTjFiem/B1wYBJRKdk
         FYSHpUCWIUusiLQL7PD5HlTVe/BNvvHx5FMdnKv7skg+YShiwPJb7IhRSuzlKPA0lwK/
         iqyUOumfTMQiy79WhGmZT/lQaWYTKP7TJlMcj7xifCW0KQ+TcCagqcsBl2mIRHv3pVDF
         7Q+05egMeqt2jxeH3TWOIjmwNTulw3XlAlsi57Rr/SlVZvZ/7euRebL9O9rhC1UP5j2w
         xgiQ==
X-Gm-Message-State: APjAAAWEXMRJiyhv0PHtbVBGmNYvxyUDfKTber9qkVY7eDZrmRtVYQEv
        cBcQMx/eVEO8ebHxz9yu9sJynkiZOO8ea0VqfIct8g==
X-Google-Smtp-Source: APXvYqxDWy1bqkocWYsCcW5FkJD8w0mUMxjpKNO7AdgtcQ7Noz4Q/THaRoC0rH8e8h0QTll7sGarHvUBCSbZMQ0joFE=
X-Received: by 2002:a2e:b5b7:: with SMTP id f23mr338566ljn.236.1573605089077;
 Tue, 12 Nov 2019 16:31:29 -0800 (PST)
MIME-Version: 1.0
References: <20191112171313.7049-1-saeedm@mellanox.com> <20191112171313.7049-9-saeedm@mellanox.com>
 <20191112154124.4f0f38f9@cakuba>
In-Reply-To: <20191112154124.4f0f38f9@cakuba>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Tue, 12 Nov 2019 16:31:19 -0800
Message-ID: <CALzJLG8ZiBdibjwY+xg0iBgqoEC1BFLcejTyHZYfsfbB7d20cQ@mail.gmail.com>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 3:41 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 12 Nov 2019 17:13:53 +0000, Saeed Mahameed wrote:
> > From: Ariel Levkovich <lariel@mellanox.com>
> >
> > Implementing vf ACL access via tc flower api to allow
> > admins configure the allowed vlan ids on a vf interface.
> >
> > To add a vlan id to a vf's ingress/egress ACL table while
> > in legacy sriov mode, the implementation intercepts tc flows
> > created on the pf device where the flower matching keys include
> > the vf's mac address as the src_mac (eswitch ingress) or the
> > dst_mac (eswitch egress) while the action is accept.
> >
> > In such cases, the mlx5 driver interpets these flows as adding
> > a vlan id to the vf's ingress/egress ACL table and updates
> > the rules in that table using eswitch ACL configuration api
> > that is introduced in a previous patch.
>
> Nack, the magic interpretation of rules installed on the PF is a no go.

PF is the eswitch manager it is legit for the PF to forward rules to
the eswitch FDB,
we do it all over the place, this is how ALL legacy ndos work, why
this should be treated differently ?

Anyway just for the record, I don't think you are being fair here, you
just come up with rules on the go just to block anything related to
legacy mode.
