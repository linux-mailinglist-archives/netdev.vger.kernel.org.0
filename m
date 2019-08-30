Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BE9A3953
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 16:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfH3Ofg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 10:35:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45715 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfH3Off (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 10:35:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so8185709eda.12
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 07:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xv+PifgPAxeC79F5Eco6ULXkrtIk3oWfd7tGCmKW700=;
        b=TBgZ1H6jO/vUXRKSvS3S2kelYpNc+WWploXOGiuwr8B/IYCttZRHdPT14LZIFzmiHC
         0WW8IrEXGHF8o6Q1Ff01uCAOSy82THMp++i21IibhvwP5M4DrtiSTVhODpx2a2ViUkCW
         YpiBQygoQLmZm+dBpcOVgT1RnRio5Q6Hiwlw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xv+PifgPAxeC79F5Eco6ULXkrtIk3oWfd7tGCmKW700=;
        b=hEowpjXfkUExbMHabcTG5nTHnyQ9hwhX9zb4fKyUBaODj8psIZNyAUsVGoymq7kGvH
         eAhpwJeoBRqwSy+R6M3X4HKFrj0u5n15t8vYlYbV34jOpiiJraSSG7jBorbCjcoj0QDx
         GywqJCgzdPZv5A3zjQW3BU0Sr74XG5eoJrNqYqTkMF7K9MLrPJDkTA4FSJnjxKhwXbOd
         d3OSz5N6e7mKN2nfRB9zry7BaFKGnbLq05YyhL2KbrWSGTpiV1D+sBUzV+soWu2XU/yT
         t6hquuI/Pa6ae1yL9euPK00011doielTgVRO7G+5gbWUrlevJ914PlVJdEMgrZ8OyFRA
         ZNcQ==
X-Gm-Message-State: APjAAAXCXuoqnEXev5XxIRUMAyPujHNI744ANpEhdOHkTRA4GkzjAozm
        BGBoeEyygfA/04+FSKCr0kIVrG2QzyCDAV3JL9ewT5/A
X-Google-Smtp-Source: APXvYqzQ237Ha9djj6kuXhydZjObG3cSVGN39EyY0BrW0Raa51Upz23VbRsRCLLreFiXDPWWaI5ShSgyVvVc6ka0jkQ=
X-Received: by 2002:a50:ee08:: with SMTP id g8mr15970645eds.291.1567175733912;
 Fri, 30 Aug 2019 07:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190826151552.4f1a2ad9@cakuba.netronome.com> <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho> <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho> <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho> <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
In-Reply-To: <20190829052620.GK29594@unicorn.suse.cz>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 30 Aug 2019 07:35:23 -0700
Message-ID: <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Aug 28, 2019 at 09:36:41PM -0700, Roopa Prabhu wrote:
> >
> > yes,  correct. I mentioned that because I was wondering if we can
> > think along the same lines for this API.
> > eg
> > (a) RTM_NEWLINK always replaces the list attribute
> > (b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
> > (c) RTM_DELLINK with NLM_F_APPEND updates the list attribute
> >
> > (It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
> > case. I have not looked at the full dellink path if it will work
> > neatly..its been a busy day )
>
> AFAICS rtnl_dellink() calls nlmsg_parse_deprecated() so that even
> current code would ignore any future attribute in RTM_DELLINK message
> (any kernel before the strict validation was introduced definitely will)
> and it does not seem to check NLM_F_APPEND or NLM_F_UPDATE either. So
> unless I missed something, such message would result in deleting the
> network device (if possible) with any kernel not implementing the
> feature.

ok, ack. yes today it does. I was hinting if that can be changed to
support list update with a flag like the RTM_DELLINK AF_BRIDGE does
for vlan list del.

so to summarize, i think we have discussed the following options to
update a netlink list attribute so far:
(a) encode an optional attribute/flag in the list attribute in
RTM_SETLINK to indicate if it is a add or del
(b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
(close to bridge vlan add/del)
(c) introduce a separate generic msg type to add/del to a list
attribute (IIUC this does need a separate msg type per subsystem or
netlink API)
