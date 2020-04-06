Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9881119F90F
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgDFPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:42:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44411 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgDFPmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:42:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id x16so13159913qts.11
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 08:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=At+NTiGU2trp8kWapxG5D4mNR7ktJvRyJwVjG76N5hQ=;
        b=g/z1q0TO19WG8RKSx/rvDi+uX3IQ3GjHjMxuqRyxVIK3HYusgHCOhQNH/Y6koSJ/Vl
         DGX6exDxRVJtCOCsgWJCILYx1d146kYGXIIEf4ZfGd3cpSL1qeQrHqz6VycUXAsEs332
         zQrRhXMYeyyv/qaXZN2N3DaMiUOeqfCKkS3ME0P1cUyWtVpWX4HoGA/JMIjMbTJT9Uhy
         6OOansSNAK2E8Z2QHDyHxPB4u53NtiED3O86aL4VAWyS3kyE+24ddXLa0aWVw5c+RIcp
         4n2foWP22/Z36UZaYdyvURjH7xoDvrSCS4OjRWL9Fkfz7Cb/i9ag7lsAnx4ndKmL1riy
         uGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=At+NTiGU2trp8kWapxG5D4mNR7ktJvRyJwVjG76N5hQ=;
        b=rwe8zNlU/p/dQZDfOfLEJ17lyqNV1PbpvKw9JdRVFffx4xVd2lHxQ6cTjk777sAkZ+
         5IrHLoAB9RXHl3IPIwsAsFXSrz9ZscPLhphXvy5nPr3ksq1REr8aEes4yyR93mXCtcmS
         h9u/xxae9A3CbNQIcZDCWO/82l1BRgFPdVKXm3Kkv6MlfijXNloXUnwbxOHbpAPY5Xgz
         x2oCPM0ZsGFcW51CNsqJ6RdWHMO0stXQsz77iU1hLShf8MCzeY9bWCNkvEmllbKy37OJ
         mwQEn7YOlAgYiVsd8otTjiO3D11hZBFkgugV4DFagpBTn5vPmJ7WNC27MZvoZ1Ezf3wu
         TtNQ==
X-Gm-Message-State: AGi0PuaxtdCz35dCp7sOdaypolZp25w+0zwd1sx3nZOkuMDiR7d23xkP
        PsWm9xTAoI24u3IjqYstFRxXskP4
X-Google-Smtp-Source: APiQypJ8Ohrn7m5fz4G40vWn36uO85EuLspk/TTxuBjL1Fh/T/QN/jUTcMUCrIY6XK1i+dXfDoro8A==
X-Received: by 2002:ac8:346f:: with SMTP id v44mr21028733qtb.205.1586187755752;
        Mon, 06 Apr 2020 08:42:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p14sm744607qkp.63.2020.04.06.08.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:42:34 -0700 (PDT)
Date:   Mon, 6 Apr 2020 11:42:33 -0400
Message-ID: <20200406114233.GD510003@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: Changing devlink port flavor dynamically for DSA
In-Reply-To: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Apr 2020 13:42:29 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Hi all,
> 
> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
> connect to separate Ethernet MACs that the host/CPU can control. In
> premise they are both interchangeable because the switch supports
> configuring the management port to be either 5 or 8 and the Ethernet
> MACs are two identical instances.
> 
> The Ethernet MACs are scheduled differently across the memory controller
> (they have different bandwidth and priority allocations) so it is
> desirable to select an Ethernet MAC capable of sustaining bandwidth and
> latency for host networking. Our current (in the downstream kernel) use
> case is to expose port 5 solely as a control end-point to the user and
> leave it to the user how they wish to use the Ethernet MAC behind port
> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
> disabled. Port 5 of that switch does not make use of Broadcom tags in
> that case, since ARL-based forwarding works just fine.
> 
> The current Device Tree representation that we have for that system
> makes it possible for either port to be elected as the CPU port from a
> DSA perspective as they both have an "ethernet" phandle property that
> points to the appropriate Ethernet MAC node, because of that the DSA
> framework treats them as CPU ports.
> 
> My current line of thinking is to permit a port to be configured as
> either "cpu" or "user" flavor and do that through devlink. This can
> create some challenges but hopefully this also paves the way for finally
> supporting "multi-CPU port" configurations. I am thinking something like
> this would be how I would like it to be configured:
> 
> # First configure port 8 as the new CPU port
> devlink port set pci/0000:01:00.0/8 type cpu
> # Now unmap port 5 from being a CPU port
> devlink port set pci/0000:01:00.0/1 type eth
> 
> and this would do a simple "swap" of all user ports being now associated
> with port 8, and no longer with port 5, thus permitting port 5 from
> becoming a standard user port. Or maybe, we need to do this as an atomic
> operation in order to avoid a switch being configured with no CPU port
> anymore, so something like this instead:
> 
> devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8
> 
> The latter could also be used to define groups of ports within a switch
> that has multiple CPU ports, e.g.:
> 
> # Ports 1 through 4 "bound" to CPU port 5:
> 
> for i in $(seq 0 3)
> do
> 	devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
> done
> 
> # Ports 7 bound to CPU port 8:
> 
> devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8
> 
> Let me know what you think!

From the DSA perspective, this would just be a devlink callback translated
to a ds->ops callback implemented by the driver to validate the different
types supported by a target port as well as switching between them at runtime.

I like this idea actually.


Thanks,

Vivien
