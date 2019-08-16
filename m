Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FEF90B4A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 01:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfHPXFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 19:05:40 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46182 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbfHPXFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 19:05:40 -0400
Received: by mail-qk1-f193.google.com with SMTP id p13so6024694qkg.13
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 16:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ifRkAu630Kd29Xg9npaDw6ve4JGdAq1Yyz5NxayUSLw=;
        b=QwpeITcdHKJhaJ/l9AmQ+TXkNjwtAcKMbdcleVdotbXhw6GDaUFoJwoEjXLDPWLFxR
         S8JkQ6lp0QCqxYzHJaJVRPZif5XCsR+y5akQH7xMY7Chvsn21unhx3xPBALBPHVg4gD6
         HsZWrOlQFGvIjuNRComCTxjUp6JY0M3t/Y9nShHQNUTKkBwEfvp18AQI+IkGS5kQcJW5
         6ZN31N+01CJ/S9ZAjXafj9Fh4t+wCBxDZmzHnj3YNbppb9YlejQpOi08a6oXdSDECKWz
         zV7CrTnBTW0cwJAymeqpVNyd284AhgRlCK/Fo9/1nr1eMs31z59MAZuhrRlBnYnuZonJ
         f3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ifRkAu630Kd29Xg9npaDw6ve4JGdAq1Yyz5NxayUSLw=;
        b=Kk7O1U40HGq1HhCv0pYU+IX1sMZvU3JnstE1kfZ4tWlcMPph1Idd+MJQ3Vr5IHE+Hj
         Ceip9EGnn/YcMIn64qLgQeUSqVRREOu55HGhbNJxKzsjSb7htUYj2XJVuGCZgGzKeTVQ
         wY5A5D71bmDfIUC79gWS7AAEWHGJ7dt9EGNtiA5hgktE6KoClj2PNaqz8nsCH7y6vXEM
         ob5AFDYfz5FIadNGevBXAdATyylYpyH06ImM4Wj8ChPNKdAjSP9ONeNCwRAL8HbNim0U
         nsTaXArY42IayI3AiE4+l5wssy8J/cZpg8I1pb3dy2lCiANaDSkt7bMSbIpGeiFGF03M
         UP4Q==
X-Gm-Message-State: APjAAAU6q2gAoHZVt4p/hVDV+lP86r8gglLaqQtfRCSNhlvOgslqhcwl
        z71NuF9Xj9xtZfDMtCmAUJ0=
X-Google-Smtp-Source: APXvYqxBX480TDWMnTFzVZCkb0xPiQ7/ijsZQNv8MQez2KkAUEvn72K4JxL0awy0Pxx7oQ1Bbjgdjg==
X-Received: by 2002:a37:a492:: with SMTP id n140mr10428057qke.137.1565996739410;
        Fri, 16 Aug 2019 16:05:39 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d71sm3705531qkg.70.2019.08.16.16.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 16:05:38 -0700 (PDT)
Date:   Fri, 16 Aug 2019 19:05:37 -0400
Message-ID: <20190816190537.GB14714@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
In-Reply-To: <20190816190520.57958fde@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
 <20190816150834.26939-4-marek.behun@nic.cz>
 <20190816122552.GC629@t480s.localdomain> <20190816190520.57958fde@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Fri, 16 Aug 2019 19:05:20 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> On Fri, 16 Aug 2019 12:25:52 -0400
> Vivien Didelot <vivien.didelot@gmail.com> wrote:
> 
> > So now we have mv88e6xxx_setup_port() and mv88e6xxx_port_setup(), which both
> > setup a port, differently, at different time. This is definitely error prone.
> 
> Hmm. I don't know how much of mv88e6xxx_setup_port() could be moved to
> this new port_setup(), since there are other setup functions called in
> mv88e6xxx_setup() that can possibly depend on what was done by
> mv88e6xxx_setup_port().
> 
> Maybe the new DSA operations should be called .after_setup()
> and .before_teardown(), and be called just once for the whole switch,
> not for each port?

I think the DSA switch port_setup/port_teardown operations are fine, but the
idea would be that the drivers must no longer setup their ports directly
in their .setup function. So for mv88e6xxx precisely, we should rename
mv88e6xxx_setup_port to mv88e6xxx_port_setup, and move all the port-related
code from mv88e6xxx_setup into mv88e6xxx_port_setup.

Also, the DSA stack must call ds->ops->port_setup() for all ports, regardless
their type, i.e. even if their are unused.

As a reminder, *setup/*teardown are more like typical probe/remove callbacks
found in drivers, while enable/disable are a runtime thing, switching a port
on and off (think ifconfig up/down).


Thanks,

	Vivien
