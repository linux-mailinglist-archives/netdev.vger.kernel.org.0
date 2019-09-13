Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621DCB2134
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388842AbfIMNkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:40:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38161 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388387AbfIMNkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:40:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id j31so7086542qta.5;
        Fri, 13 Sep 2019 06:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xmI9iPIdJysE5tnfxO8lsWvpznjbaH/zYgd78oe6pMc=;
        b=K8AxzN7dUoev/3ENnB76BRjOzI9UPZoY8NWtJUtXcG6I/oqyE+QfDfwguNeHJbXYiI
         hFujhu8T2eIwkgSgDeeaGyJYx2/tguOjKGAZsD/sb4/6GVaw2fIXdpxTttZMEAabaKjW
         1q47Dosck/ZU1X553U6FF0eGBG00XCrfcRm+F5ojDq8iqfqYGHmqLwN3BaSIwkxMqx/w
         ixQF0c7XA4rEbIx/ZZJXnBhZR0p/5Aqzh2/e+RUZJJR+lwafaKNCiVmdWuhKlqtN2STE
         8pnNzAGGyK1arNFzzYe6sZy6DC5jtUn2UKCiQSB1Zg8jb5HbmFtx2VBdI9Dx88SyvvzA
         ARPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xmI9iPIdJysE5tnfxO8lsWvpznjbaH/zYgd78oe6pMc=;
        b=I8mN4L/Tz2zobNkduEseojmx3fbuKauLe45AObe1DQiVBTISmTHXEqvDYSDP/SwlnC
         zvTERHe4mtaF3fsM0qcP2o5PZvqK9oGeiiwOSpcKJd+AdqG34j+VLygDS5H1ACrjMAdk
         Q5TilGQMf6yH5erewHGBBm3BJdfW51LY9fjh+go1e1MhWjtIREqMiwuTmvMmj5zCjxgZ
         lOPRlKMnLAYPDEw+WUnQuPj6VseaZKnz4KkGCWq08DrB0kzAkaNhMZutBtMStFz2J0jV
         hnypBc+XYrgCA1ALvuV7iiOQ2qTbcxITTRpnIw3O7rzgtAFitK6uFWiBFqkrnslWRLQB
         mKrA==
X-Gm-Message-State: APjAAAVpN2Svg59vAGe+yUgBz8YqMOTosiWydcYfBZnwBhUO69LVvIi8
        p5OTS1XaSAmspyWIDZIjb6I=
X-Google-Smtp-Source: APXvYqzxWaOUC6qZwMBuCHnyzenzRSRzTHSbE0gzNUTOFToej+bows67Ufyy7HBJJk5zXK4cbd1Yww==
X-Received: by 2002:ac8:3021:: with SMTP id f30mr2952481qte.193.1568382004037;
        Fri, 13 Sep 2019 06:40:04 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f01c:48c2:8ccf:8b81:8d41:df1e])
        by smtp.gmail.com with ESMTPSA id h4sm11450080qtn.62.2019.09.13.06.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 06:40:03 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D7FABC4A55; Fri, 13 Sep 2019 10:40:00 -0300 (-03)
Date:   Fri, 13 Sep 2019 10:40:00 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Message-ID: <20190913134000.GY3431@localhost.localdomain>
References: <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
 <20190912225154.GF3499@localhost.localdomain>
 <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
 <20190913131954.GX3431@localhost.localdomain>
 <be14cc8353f6403c82ad81e3e741d8f0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be14cc8353f6403c82ad81e3e741d8f0@AcuMS.aculab.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 01:31:22PM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 13 September 2019 14:20
> ...
> > Interestingly, we have/had the opposite problem with netlink. Like, it
> > was allowing too much flexibility, such as silently ignoring unknown
> > fields (which is what would happen with a new app running on an older
> > kernel would trigger here) is bad because the app cannot know if it
> > was actually used or not. Some gymnastics in the app could cut through
> > the fat here, like probing getsockopt() return size, but then it may
> > as well probe for the right sockopt to be used.
> 
> Yes, it would also work if the kernel checked that all 'unexpected'
> fields were zero (up to some sanity limit of a few kB).

Though this would have to be done by older kernels, which are not
aware of this extra space by definition.

> 
> Then an application complied with a 'new' header would work with
> an old kernel provided it didn't try so set any new fields.
> (And it zeroed the entire structure.)
> 
> But you have to start off with that in mind.
> 
> Alternatively stop the insanity of setting multiple options
> with one setsockopt call.
> If multiple system calls are an issue implement a system call
> that will set multiple options on the same socket.
> (Maybe through a CMSG()-like buffer).
> Then the application can set the ones it wants without having
> to do the read-modify-write sequence needed for some of the
> SCTP ones.

I'm not sure I get you here. You mean we could have, for example, one
sockopt for each field on each struct we currently have? That would
bring other problems to the table, like how to deal with fields that
need to be updated together.

Anyhow, I'm afraid our hands a bit tied here. That's how the RFCs are
defining the interface and we shouldn't deviate too much from it.

What would help is that the RFC definited these versioned structs
itself.  Because as it is, even if we start versioning it, Linux will
have one versioning and other OSes will have another.

  Marcelo
