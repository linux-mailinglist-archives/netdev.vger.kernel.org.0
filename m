Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73612281CB2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJBUNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgJBUNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601669583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JEA567/T1YVaTHkPnZGy8nWmG2WU769exGNrto6IMdE=;
        b=fjIBp7Got3zcBQATMdbvE1e39EkEOL4c1AE4olubUlPSqZOHRZtL5NDpy+rqf3aRHDa9Bw
        taM40KB3W3lCLqzYzU2AFvon2iDJaP3cCNTlJ0VEjEC3RZBhUW49KIW1W/YM+E/GGqfey/
        km2mnmuGvgL6JWrDLPhuWjRsQmq+54U=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-YlCrtwXtNCWMVxToFTEWxw-1; Fri, 02 Oct 2020 16:13:01 -0400
X-MC-Unique: YlCrtwXtNCWMVxToFTEWxw-1
Received: by mail-oi1-f199.google.com with SMTP id s10so453001oih.10
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 13:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JEA567/T1YVaTHkPnZGy8nWmG2WU769exGNrto6IMdE=;
        b=baLt5ynNY+3vlE72r0K0LVSUjL1eT0wTLn9KFaYXxce/fe94sL+hqvDLW509qRzgMP
         gSYYjaPHdTm+Y61mXRxfBfK0j9wwDkD+Vgp4TurViZXEXENaFAoMazdkQqSFuGjTXBa0
         ZUxHLa3CZBDg/yFI9L1TDdluKdUMp7bp3i7AmaxUDGuJ5eFV9Y34aA5gVGyu7wec+10o
         q/TYYAqBdl/TWG9JKZZ1csFK8X1l+wTRTYMs5atyR6G+uhb1civdPTxQAnVlkMe2BUBv
         kLE93EVe454B7Ho3YjxjuuwJUD8TeCL1oOPVoLWi5JMNFf+u0oh6e0rd2z+LSZbv2vqi
         BkNQ==
X-Gm-Message-State: AOAM532QyIRT2CvxpUusgI/E2fTTRGA+QQIOLDQWCpxPUJcDXLx8EH9k
        QgFYQ8r4UyE5vYyJsVF615ZS8zGpLA0tYxjtDEjUPZtkMrRkoexkfuh0Tt/pnNjKKJlCkJx79GM
        KE5eOsiFiTTOXtYrmbxCNfVCZIS+JbBSn
X-Received: by 2002:a9d:6c4f:: with SMTP id g15mr2968718otq.277.1601669580663;
        Fri, 02 Oct 2020 13:13:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjj9nlQwmwXjZdO4Ufa9bzBeHpRccUJkfdIO6OXpxZOtLIcbkvyRpVwmUw6l80CbxhDYAWys7PpBFv2FQ9LQo=
X-Received: by 2002:a9d:6c4f:: with SMTP id g15mr2968701otq.277.1601669580438;
 Fri, 02 Oct 2020 13:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-1-jarod@redhat.com> <20201002174001.3012643-6-jarod@redhat.com>
 <20201002121051.5ca41c1a@hermes.local>
In-Reply-To: <20201002121051.5ca41c1a@hermes.local>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Fri, 2 Oct 2020 16:12:49 -0400
Message-ID: <CAKfmpSecU63B1eJ5KEyPcCAkXxeqZQdghvUMdn_yGn3+iQWwcQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] bonding: update Documentation for
 port/bond terminology
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 3:11 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  2 Oct 2020 13:40:00 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>
> > @@ -265,7 +265,7 @@ ad_user_port_key
> >       This parameter has effect only in 802.3ad mode and is available through
> >       SysFs interface.
> >
> > -all_slaves_active
> > +all_ports_active
>
> You can change internal variable names, comments, and documentation all you want, thats great.
>
> But you can't change user API, that includes:
>    * definitions in uapi header
>    * module parameters
>    * sysfs file names or outputs

All of those are retained by default here in this set. There are 0
changes to the if_bonding.h uapi header, module parameters with 'port'
in them have duplicates with the old terminology included, and all
sysfs file names are duplicated (or aliased) as well. The
documentation was updated to point to the new names, but the old ones
still exist across the board, there should be no userspace breakage
here. (My lnst bonding tests actually fall flat currently if the old
names are gone).

-- 
Jarod Wilson
jarod@redhat.com

