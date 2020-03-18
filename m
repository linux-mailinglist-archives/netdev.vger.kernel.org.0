Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791391893FF
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCRC0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:26:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38291 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRC0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 22:26:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id z12so209101qtq.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 19:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=T/Urqk83SlmgqPe6Ia/iCxEK3eI5p/CJgzdx5zdL0zY=;
        b=fmvXkstPdQAULrxaG/YduhIrMxvcYk8zLHZCy8X7a/hQH/gi2olKZ+9hJdP+yaAXyj
         rQxh/WtPDpcUxDrQZby8KhAX37G0XyAkqfYhLzSfSkfmrK7CN1J6Le8x+F9qzJ+hLeNv
         vYPm/c82g7EeR8/Zuu6ZxIsbzzyQL/Rj/nwixOfffuy8AbyhzDTWdI+nrE1BvL+qpEXH
         sFn4uq3kbMMz/BblSxluKxus1yhx3NU8oMc6lOpdf5UKBRA+voBKWFo/kGOkdsqftHUq
         OLuiB0cfB9fwqmz1C61TibEQXW2P0JPqaxE6ngZmFlhZCq8Ih/XQELuuts043yj8Ira3
         CIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=T/Urqk83SlmgqPe6Ia/iCxEK3eI5p/CJgzdx5zdL0zY=;
        b=ajx91McquGYDR1ox6XEVxpFvDAc5fiptEJgRU3ogP1eiPqeLDLhpdbWLLgM2vBlHWv
         CT0tSWvA+03AOfuVnvaMN+I6c4MQvjWissMAhhgmJxA9JN/IKtfkKCD+f/oHVBb0RvQd
         nlpOonhl5117rV4XRFSzCGPJa9i0bJZNcVTkKQ2l5nDWeuSk1rH/jVr00LmR47aRI4ug
         pN1Y1MnHKciyHf2R7OZI++LCw2/I9uXdy1zstqr5XfWLZ6dRtW0bSyJ+HH1UI2d1SZi4
         /jsLocMF0eIL6U0gjwnv+CVUUJ5crEulsjPFEj3jl8ZPkoLhNrkVElHeKYtLPhWduN3c
         Hr9Q==
X-Gm-Message-State: ANhLgQ2+wpGl81hfDhxbc5NUO9/sdjekjJwzswiYuyivNN0cpqmGnvYC
        af0XYy1J0BJybL9bxZty/us=
X-Google-Smtp-Source: ADFU+vvpeh7EVfEvVfXr5o+PemqTtHMtkJaxmZw+fRi38KFQ8OsosmWBjxaFyOG341jL/0vX+Meffg==
X-Received: by 2002:ac8:7496:: with SMTP id v22mr2250102qtq.291.1584498400586;
        Tue, 17 Mar 2020 19:26:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b145sm3295268qkg.52.2020.03.17.19.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 19:26:39 -0700 (PDT)
Date:   Tue, 17 Mar 2020 22:26:38 -0400
Message-ID: <20200317222638.GB3226601@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
In-Reply-To: <20200317212453.GV25745@shell.armlinux.org.uk>
References: <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk>
 <20200317120044.GH5827@shell.armlinux.org.uk>
 <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
 <20200317151238.GQ25745@shell.armlinux.org.uk>
 <20200317144906.GB3155670@t480s.localdomain>
 <20200317212453.GV25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 21:24:53 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > In response to your 3/3 patch, I suggested commands to test setting up a
> > VLAN filtering aware bridge with your own default PVID before enslaving
> > DSA ports. Unfortunately you left this unanswered.
> 
> I don't believe I left it unanswered.  However, I'm not about to rip
> apart my network to try an experiment with specific set of commands.

In mail 3/3 I suggested to run the following snippet to configure the bridge
at creation time so that we can see clearly if the problem still occurs:

    # ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 42
    # ip link set master br0 dev lan2 up
    # cat /sys/kernel/debug/mv88e6xxx/sw0/vtu
    vid 42      fid 1   sid 0   dpv 0 unmodified 2 untagged 10 unmodified

You skipped this, last email without reply, this feels pretty unanswered to me.

But whatever, I don't want these two commands to rip apart your network.

> It is my understanding that Florian actively wants this merged.  No
> one objected to his email.
> 
> It seems there's a disconnect *between* the DSA maintainers - I think
> you need to be more effectively communicating with each other and
> reading each other's emails, and pro-actively replying to stuff you
> may have other views on.

I'm not sure to understand what you're assuming here. As Florian said, your
patch is good to go as long as you change the boolean name to something
generic not containing "vtu", which is Marvell specific. If you really
need us to choose, then go with "force_vlan_programming" or one of your
suggestions. What matters here is that a non-mv88e6xxx user can clearly
understand what this boolean does.


Thank you,

	Vivien
