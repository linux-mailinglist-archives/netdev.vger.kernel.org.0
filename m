Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777139705F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 05:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfHUDaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 23:30:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36978 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfHUDa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 23:30:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id s14so652309qkm.4
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sq9fx9GMYh90EDNp9r48nydmLa8jqoUXCcyh9dQly6k=;
        b=pBbwwTaEscuJuxf7vRk5dv9JRDy7ovrWJJ86vpGlbJtjoYtWqTfKZR5XHyQaHUKIM/
         D43u9c9ugl0+u8YUCrJ/EWQTSa13OCiFDJv9sLym2U1ZxXtE8lWDzTvQqWtXT0bTRZpN
         8IabeNlvOi2KSqdEdiutWGwv8kDKIZc9ObXDeHFgw4Hq7thni94pwHoDdI5fXrNM2C2V
         vukSzqn5gmz2MjurbUZmOv9Q+JgbtCpSvrSrOagDp7QvNJ0uF+hoxBVztu/A2jtjClzM
         qqkWLZi9LEDwU9zeM0/Cyp49l3uX5B81QlTDNhVXi/D7b9s9xGsCSpWiv9hl8uBp0Sjb
         QzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sq9fx9GMYh90EDNp9r48nydmLa8jqoUXCcyh9dQly6k=;
        b=jomB/BtuJNw9cCOxe5R+yb9VBugKIPuzl9XbZxKCz7RZ+ln/ekMcEoFfbaht7/5s05
         4hanUJw9XolZvoiZSghAOm+BW21fUuS+mUcDHRMVSk+fpQ/OhSLypnhtYw1m2CkQaH3P
         PILzDeQFEEt4CLcmMvWOZ/aErismyPRr93X1pKjv9ejIKPTP7msXInmA7/mxPJpE2Rg+
         eIetltoNc9LA8i8enSPiebSP0idQ2UtQABPGx2icMZj+MQDfvOChFXHhqdm3Zl635BXm
         lZx6EXlBESYtpApgWBfc5Tx3fQzH77xQBTHqYEPOGVgnLocE75lFyoKdDg8UykmJ09CW
         HURA==
X-Gm-Message-State: APjAAAV+5K8+BdmJnn3H52kC2PQnAV/vCXEJ+HVS1JaoTCUlf5pzf6rF
        vMn/vHp55SzdYc/3V78RDgA=
X-Google-Smtp-Source: APXvYqxX3JFmjhUtu5PDsvyozFbmjtgAET1HnGMsoLIioV4jHF6pc9HaP4qGanO9yktFjyuzJgOVQg==
X-Received: by 2002:a37:a2d1:: with SMTP id l200mr29440535qke.63.1566358228843;
        Tue, 20 Aug 2019 20:30:28 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o27sm9359284qkm.37.2019.08.20.20.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 20:30:27 -0700 (PDT)
Date:   Tue, 20 Aug 2019 23:30:26 -0400
Message-ID: <20190820233026.GC21067@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
In-Reply-To: <CA+h21hodsDTwPHY1pxQA-ucu6FU7rkOQa7Y4HJGZC0fRd8zmDA@mail.gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
 <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain>
 <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
 <20190820165813.GB8523@t480s.localdomain>
 <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
 <20190820173602.GB10980@t480s.localdomain>
 <CA+h21hodsDTwPHY1pxQA-ucu6FU7rkOQa7Y4HJGZC0fRd8zmDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 01:09:39 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> I mean I made an argument already for the hack in 4/6 ("Don't program
> the VLAN as pvid on the upstream port"). If the hack gets accepted
> like that, I have no further need of any change in the implicit VLAN
> configuration. But it's still a hack, so in that sense it would be
> nicer to not need it and have a better amount of control.

How come you simply cannot ignore the PVID flag for the CPU port in the
driver directly, as mv88e6xxx does in preference of the Marvell specific
"unmodified" mode? What PVID are you programming on the CPU port already?


Thanks,

	Vivien
