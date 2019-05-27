Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE62B76B
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfE0OUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 10:20:41 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:35908 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfE0OUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 10:20:41 -0400
Received: by mail-ua1-f52.google.com with SMTP id 94so6512902uam.3
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 07:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=GRDM+09CmbscX0g6PSyBLWHUN7zjiL0rp0jCImVU5Gg=;
        b=BZdFs0lNPI0YNSNzBcYfu8KCq/r2GvYq5f4yjRP+u21Jlgi6hTCeB27oQgtJrvY3sM
         ShVFhuVLF2UGR+CU3jKNBHz9jlCTabrjKDHuDBa0pFjJSWzMmS3N+8uJDduD36u+HeH4
         6beG3iaPPPUnaUWFYikXdNAWpBuzNmP/F8ev2ZnarrFY1XO9XIbXpUyeQoFTOnib0ntA
         SsAJ8zo8bFyQjvbxvgifnwwOr+WbWFJUPDCCGz3xLM+2F6478tNtutD+Ecgnr6HA0T3w
         Jm6WZYsScpdzghdiLsLvGOUZDg6V2lsUk+fs82aVmAOyZvLB13ifOyZesh0P/1T6+CHA
         aukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=GRDM+09CmbscX0g6PSyBLWHUN7zjiL0rp0jCImVU5Gg=;
        b=qLKOdTxKvI6hZCCrMFqPvUnof9ioacDqYCFGUMqE9BVA9xyT6ioKiy+NNWKDNZox6R
         A57uQ3mxOK+lQ4phylAMvN8OakARP8xeikQAnZsYCxcrWxFaJ2q6vI0GMklT2Atoxn7H
         PMxTPlYunbywtPy7Ms68tOY261SG75lfCJtf56MG7CdG+d933P+2B4+E242ydMjyBzfm
         OEQoJJ30Hc1ysO4GFQSwuvevwnm9LZGVh354kP8jMgWNIcsqqIhmj9VyvQtJ2zv8sTpM
         QIracVsRpO2bQYfTCM6KRzu4tVdSpDt6+HWOX3MRJo9ejVxqeHiQH5GAFoBuZtRa37yE
         CTjA==
X-Gm-Message-State: APjAAAVfnDKHQ4s4AzpsL6oTh3cHOUQa1qKN0hvEjjRQCMqX27Ns1H9A
        xe6kMdkPml+EeSRnGD22LsFRbnvz
X-Google-Smtp-Source: APXvYqz9M3X6wjyDEXYtF+RAK4TZ+pDeWj8WVQO95PadT5q5j7uLwJYjror3t8tTd5c3h6MHpJnCEQ==
X-Received: by 2002:ab0:4a97:: with SMTP id s23mr20689277uae.19.1558966840355;
        Mon, 27 May 2019 07:20:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q69sm4746371vsd.10.2019.05.27.07.20.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 27 May 2019 07:20:38 -0700 (PDT)
Date:   Mon, 27 May 2019 10:20:37 -0400
Message-ID: <20190527102037.GB31320@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: reset value of MV88E6XXX_G1_IEEE_PRI
In-Reply-To: <493a84d0-5319-41ce-1437-77daf8813d39@prevas.dk>
References: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
 <20190527083215.GB2594@t480s.localdomain>
 <493a84d0-5319-41ce-1437-77daf8813d39@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 27 May 2019 13:02:04 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> > On Mon, 27 May 2019 09:36:13 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> >> Looking through the data sheets comparing the mv88e6240 and 6250, I
> >> noticed that they have the exact same description of the G1_IEEE_PRI
> >> register (global1, offset 0x18). However, the current code used by 6240 does
> >>
> >> int mv88e6085_g1_ieee_pri_map(struct mv88e6xxx_chip *chip)
> >> {
> >> 	/* Reset the IEEE Tag priorities to defaults */
> >> 	return mv88e6xxx_g1_write(chip, MV88E6XXX_G1_IEEE_PRI, 0xfa41);
> >> }
> >>
> >> while if my reading of the data sheet is correct, the reset value is
> >> really 0xfa50 (fields 7:6 and 5:4 are RWS to 0x1, field 3:2 and 1:0 are
> >> RWR) - and this is also the value I read from the 6250 on our old BSP
> >> with an out-of-tree driver that doesn't touch that register. This seems
> >> to go way back (at least 3b1588593097). Should this be left alone for
> >> not risking breaking existing setups (just updating the comment), or can
> >> we make the code match the comment? Or am I just reading this all wrong?
> > 
> > If the reset value isn't the same, the bits are certainly differently
> > organized inside this register, so the proper way would be to add a
> > mv88e6240_g1_ieee_pri_map function, used by both 88E6240 and 88E6250.
> > 
> 
> Based on the very systematic description [ieee tags 7 and 6 are mapped
> to 3, 5 and 4 to 2, 3 and 2 to 1, and 1 and 0 to 0], I strongly believe
> that 0xfa50 is also the reset value for the 6085, so this is most likely
> wrong for all the current chips - though I don't have a 6085 data sheet.
> 
> I can certainly add a 6250 variant that does the right thing for the
> 6250, and I probably will - this is more a question about the current code.

Good catch, I double checked 88E6085 and 88E6352 and both describe
a reset value of 0xFA50. Fixing mv88e6085_g1_ieee_pri_map should
be enough.
> 
> > I'm not a big fan of rewriting the default values, but that is the
> > way we chose until we make actually use of these tag priority bits.
> 
> Yes, I was wondering why there's a lot of code which simply serves to
> set default values - but I guess it makes sense to force the switch into
> a known state in case the bootloader did something odd.

That was the idea, yes.


Thank you,
Vivien
