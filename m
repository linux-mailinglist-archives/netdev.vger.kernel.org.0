Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197093081B8
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 00:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhA1XMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 18:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA1XMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 18:12:44 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6868C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 15:12:03 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v1so6894756ott.10
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 15:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wP6FOwfJyWUSkDOtLb0ajq/mHu53yI0ES8hPkZI6jvc=;
        b=LK4hCWOL9IlxB8afVHJWANQglgPH/QIo8xZPBiseagaWUPf5mq90RBlVQJzVhPmPJQ
         5VNgJ1OXZf8UsttH/ooJn/YuWPkeQ0WrIROaZ99Alo8JyoUWQW8kyBXpSnuJNHF+dswh
         NTlUf2aDNBAS82L6RoVXaJA45Mw3zJjdf9mOQc0AUUxO984vBmuYMjrn4kJ3rRAJxdQF
         qfAva0rk+BHzJ1gaZ+3qkYv9ciyvpQ3tjutVf/rpBdRFyv5O78O4HcakLdiqg8+Qr292
         RxB2KtCWWkz8zBHwWPCku7gR5NBzcornCqkmykFLJMn6Utkox+Hx/eJt56dXVluTlMt+
         E1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wP6FOwfJyWUSkDOtLb0ajq/mHu53yI0ES8hPkZI6jvc=;
        b=ZFK7TGAD2Oy7RS4zZduAayR0lYLFj7l0J7gjLJh4KB56wbZf24Q+wrARTzInqQBDw1
         puCaEbSsG/g52qaeuQU6pK/FcdLq6JK8q3ywbXKsqiq+I0lntQVWO/FwAhlk6oP3X601
         crXC4XhPziNeOPhZMJGeM3cF+LHpeQREjvg79/08dgz6RbeFmVfUNLy2xZ9OC3/XTs7/
         oLBMkpUbRIEBuQBsKFR1l2iZxTm/wc50iB8led8lW22met6bPhIranwHJ3hv/GJ7rFOb
         lFNuQDaL3CyQYid7hn/d6XgT+cDRkN/Ykay6E7f9gQ0l2+tJG4I3My4AVMDRDxKXXOdE
         WuPQ==
X-Gm-Message-State: AOAM530qrcoQ3mGBQRBkm7L0NyL/jpUJLBqKij7C89FN9U11XE6PokzY
        BI4kDjbjBl0jQUS0FMbBpoDkjW3kiin5s3qKa8XUyfdcQ1xZ
X-Google-Smtp-Source: ABdhPJwKNqSmzs8WGHJOIB+0b42byQoTQz/crmVw4X8ekefy2B0/y4Bl+QbsEZPLgkNInzATrtLr4U/GmNOR58ql4YE=
X-Received: by 2002:a05:6830:1e51:: with SMTP id e17mr1190734otj.340.1611875523371;
 Thu, 28 Jan 2021 15:12:03 -0800 (PST)
MIME-Version: 1.0
References: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
In-Reply-To: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 28 Jan 2021 17:11:38 -0600
Message-ID: <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com>
Subject: Re: HSR/PRP sequence counter issue with Cisco Redbox
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 6:32 AM Wenzel, Marco <Marco.Wenzel@a-eberle.de> wr=
ote:
>
> Hi,
>
> we have figured out an issue with the current PRP driver when trying to c=
ommunicate with Cisco IE 2000 industrial Ethernet switches in Redbox mode. =
The Cisco always resets the HSR/PRP sequence counter to "1" at low traffic =
(<=3D 1 frame in 400 ms). It can be reproduced by a simple ICMP echo reques=
t with 1 s interval between a Linux box running with PRP and a VDAN behind =
the Cisco Redbox. The Linux box then always receives frames with sequence c=
ounter "1" and drops them. The behavior is not configurable at the Cisco Re=
dbox.
>
> I fixed it by ignoring sequence counters with value "1" at the sequence c=
ounter check in hsr_register_frame_out ():
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 5c97de459905..630c238e81f0 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -411,7 +411,7 @@ void hsr_register_frame_in(struct hsr_node *node, str=
uct hsr_port *port,
>  int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
>                            u16 sequence_nr)
>  {
> -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
> +       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &=
& (sequence_nr !=3D 1))
>                 return 1;
>
>         node->seq_out[port->type] =3D sequence_nr;
>
>
> Do you think this could be a solution? Should this patch be officially ap=
plied in order to avoid other users running into these communication issues=
?

This isn't the correct way to solve the problem. IEC 62439-3 defines
EntryForgetTime as "Time after which an entry is removed from the
duplicate table" with a value of 400ms and states devices should
usually be configured to keep entries in the table for a much shorter
time. hsr_framereg.c needs to be reworked to handle this according to
the specification.

>
> Thanks
> Marco Wenzel

Regards,
George McCollister
