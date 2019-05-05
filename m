Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2A7141DE
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfEESfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:35:07 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45322 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfEESfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:35:07 -0400
Received: by mail-ed1-f65.google.com with SMTP id g57so12721045edc.12
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxkxI6Dceuv53ziJAztSxfzBrXl7yz44Zv8edVvOsdc=;
        b=Y2sgLiB4pihzJe1mVoyZQcDaS87nNaGQ1MClh4KZhahbII5i3QSf59q2FFvYaLzq1/
         EAYaqFuLyDxmnPC8L2ff2W3rxknrMVlv/nUbG2AP6EEFacsZ5xOD+I8DnhmlgHFpMwXw
         13DBvP9zWNrcEHzuc8cyNp6F0eKotwO8ou6lQMc/8dIbhtQna11h5tW+3ZTBi9lyz62m
         7aa+3zLAN7GGDKC4zEjh1aTnwZsjLbez/pBPRi6TvDw5kjlMKac0OyyFGEkTU8GGf/sl
         pCOjVOfXo+wGm3tOJGfDvLOhTj4HXxTW9phNm9eyUkQuwwwzUbo0Bur6nuGdp+iqH2Fy
         Vaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxkxI6Dceuv53ziJAztSxfzBrXl7yz44Zv8edVvOsdc=;
        b=dZYT+knHNaQ2g1ovljMm0TGk1ZGCtegoiDFkGtH/rA0LZuvtxnwdSZdQD8HXomKnaC
         ohM57LWPlV2o1lvZ/fcGIAbRdwVehePaBxwVZqQaxMCUOKtz81ddh45CgPK9snxBZN6g
         MDugTnUgerPeBeqPznI3a7n7SkRUOGQShXLSAgBbHgyBkTq82d6gafK2hH51iuXFf2Pl
         Hl5QILhrk60PljCsXvkXCaw9y/EIyE8Leh9eQg8xU7IixVbwUfTV6BNDiSSzs5vwqeyq
         NA2bYaHwzuW/S4qopxE6XvW7kaYqIXgJQnEsC7HlGkSQvRi2W5coNBCqGNSvq7xQdURL
         Q7ZA==
X-Gm-Message-State: APjAAAXa00Onhq0bTAGsbbYx+90dHBEI3aFtZIWRT8DxF7datPj2L1PD
        lH7deJnsIbxybGYKtqdXdLI9M1zN3D1Xm9MgFBFWkQ==
X-Google-Smtp-Source: APXvYqzfQxYkmHZtzK3lja3EYfuWw/7SbjvkBVKZ6tR75sxaus9IhnnBgOeqHiKgNRLkzKi7D0HZ0p9AKV9VwLtrctY=
X-Received: by 2002:a17:906:9a9:: with SMTP id q9mr15809476eje.171.1557081305864;
 Sun, 05 May 2019 11:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190505101929.17056-1-olteanv@gmail.com> <20190505101929.17056-11-olteanv@gmail.com>
 <e9fecad2-1fcd-954d-65fa-47f0a3ce6821@gmail.com>
In-Reply-To: <e9fecad2-1fcd-954d-65fa-47f0a3ce6821@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 5 May 2019 21:34:54 +0300
Message-ID: <CA+h21hrk2CnW+AffA5tgRjZYCjOq5Ys8k6CeuDLDTjAiM7ZfUA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 10/10] Documentation: net: dsa: sja1105: Add
 info about supported traffic modes
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 May 2019 at 20:04, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> > This adds a table which illustrates what combinations of management /
> > regular traffic work depending on the state the switch ports are in.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> I have finally put my brain on and understood what you meant with the
> vlan_filtering=1 case, which is quite similar, if not identical to what
> happens with DSA_TAG_PROTO_NONE where DSA slave network devices are
> simply conduit for offloading bridge operations and the data path
> continues to be on the DSA master device.
> --
> Florian

It is similar but not identical with DSA_TAG_PROTO_NONE. The
difference being that L2 multicast traffic still goes through DSA
slave netdevices, and that is exactly why I need the filtering
function.

-Vladimir
