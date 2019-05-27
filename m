Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8912B556
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfE0McW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:32:22 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:40447 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfE0McS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 08:32:18 -0400
Received: by mail-qk1-f172.google.com with SMTP id c70so3463032qkg.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 05:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=1Db/sjvLrddlf/6ChLU6S+6957Mp97Mb1eczFJ3U84I=;
        b=QlFGicbtc7YVvA4tZQG8/fpLKwNChP4heHhQmdthcH/O8qJPMFsyiZdRUB186P3iHJ
         xzDtO9rclNYnATuJuPvU5ytg0LngyNQOuhfP2IL5h1m3KjPDwNjtFOpt0LdQ9d5vzags
         KWDT8n7sbRRuSs+y5SKKPf2W6simrW8zvMAQgBXLhWRpbBIr3yvwSzTTawPUHtSbX7bf
         EWq6eaQinhNomcp7FuGiCDb1qGNiPHWas7GnmVl/HWtGMS8dI67EPmo8woFJIrMZvajf
         WYNkAbp39yPAuRc/922PQYg/wnTVNT5J4gTFy1njtvz0aZpn8qIFSJ8PDKQV029wxN7W
         PUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=1Db/sjvLrddlf/6ChLU6S+6957Mp97Mb1eczFJ3U84I=;
        b=T465ZPbfUc09miRJ6XtwxSZKynlsFE08YFAWlCVx8orzzr1d/aXwuutAQ3WBy+s9Ue
         oPH0glmWTikvU0M3HojSTvxoujP/gspvT7DX4Ypd5O6lD4Qhz3xp1eK/yZq66xm1WzkN
         elMv8i3e2tLQzvrx47Ew9GUJ0nTubJf39f9RSplSUFRGXbyQAKlGHIkpjCjaivuLUgUI
         HDQ33k9AoUWvEZx6ZVSw//6gVpzIYYqDY2dDgECoOTj1exU/gYFhwnuQTO40zqBVf2nf
         H1qe5x3mUA9R5R1/k6hHK6a2LEjmPZkaLDjhs/lhfDnzbJ2Yobt/HTsclvOLzBhMHSmh
         uGWA==
X-Gm-Message-State: APjAAAVivcs8rwIUcmsOsTd25p6EsEMDIsXIARqAzaK35I0t2cRbgqGG
        AtvrAjG5PFvT+5lIRvLeAPE=
X-Google-Smtp-Source: APXvYqySv73dRvo7b76qNHJPNTKTThmYJJDKOQU3ZDTqsF74fslMTUvXhK6aNh9nt7feA5spI58e2Q==
X-Received: by 2002:a37:444f:: with SMTP id r76mr14791152qka.237.1558960337782;
        Mon, 27 May 2019 05:32:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 39sm5321220qtx.71.2019.05.27.05.32.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 05:32:16 -0700 (PDT)
Date:   Mon, 27 May 2019 08:32:15 -0400
Message-ID: <20190527083215.GB2594@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: reset value of MV88E6XXX_G1_IEEE_PRI
In-Reply-To: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
References: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 27 May 2019 09:36:13 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> Looking through the data sheets comparing the mv88e6240 and 6250, I
> noticed that they have the exact same description of the G1_IEEE_PRI
> register (global1, offset 0x18). However, the current code used by 6240 does
> 
> int mv88e6085_g1_ieee_pri_map(struct mv88e6xxx_chip *chip)
> {
> 	/* Reset the IEEE Tag priorities to defaults */
> 	return mv88e6xxx_g1_write(chip, MV88E6XXX_G1_IEEE_PRI, 0xfa41);
> }
> 
> while if my reading of the data sheet is correct, the reset value is
> really 0xfa50 (fields 7:6 and 5:4 are RWS to 0x1, field 3:2 and 1:0 are
> RWR) - and this is also the value I read from the 6250 on our old BSP
> with an out-of-tree driver that doesn't touch that register. This seems
> to go way back (at least 3b1588593097). Should this be left alone for
> not risking breaking existing setups (just updating the comment), or can
> we make the code match the comment? Or am I just reading this all wrong?

If the reset value isn't the same, the bits are certainly differently
organized inside this register, so the proper way would be to add a
mv88e6240_g1_ieee_pri_map function, used by both 88E6240 and 88E6250.

I'm not a big fan of rewriting the default values, but that is the
way we chose until we make actually use of these tag priority bits.


Thanks,
Vivien
