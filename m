Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324C114D7C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 16:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfEFOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:51:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33747 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbfEFOvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 10:51:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id k189so788271qkc.0;
        Mon, 06 May 2019 07:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=EUqbtnBDML3NXPrwjM3lOcCy0+gNa0GHK0Zw6wsv7vk=;
        b=AXTDnLjU4V5dPhIaqTfxEvyLYGM6Ju3eFNv0qIjyCiDhH80SqzSBl8gqCzk71+F8En
         6FZBzMHUG20Ea88H/H4v3tV6iodGgF81A4RWwPpTJptIvVzUiMQUN3vx/S2PGtidPIVu
         txpEda5KDfCAQvKaGidI40u3a2CT6ltxytWXxIgllylF3HU7mFmHw2Z3Lhy59yXdMvLM
         y6v6ykITIP9UnL7CtW8v+klC7wr/X2vN5DT1hSv9JjdgeBNj78eEV77CVowZfYziAiGs
         24NBtWK6UJTL7Z4R7jdP+qXnenOUqbd0eKNm0fGpbpg8kRu6C9MHRRt8KVF/35B4F8N/
         wEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=EUqbtnBDML3NXPrwjM3lOcCy0+gNa0GHK0Zw6wsv7vk=;
        b=BBSKYS91VIRrvwbeJ/IEG5BZT5sFbgDcbDcbikYZPQ/PWwiMnwfF1BZ30qeWbw46as
         8+AXx+e6XlpS+IJAy2Zf1Ougm2IYP+2Rt+Lrh7KUUBwpbw8Y9DLHWDFnJmKvC4Kqp8os
         DYXCobpAH/bJLqoe9Fa903h5V1I3dlo2i0wVaM7df3DmTIYLRh5N3fr0Q0gaE4hKlvyA
         oEJIKqA6nOVpK31aDXonlciehtea0wwRlETwFswzvtFqR4LZfqaj/+zMZ1C9dTgW4IAp
         zsblnQjyWAy3xkJMw2QAneHVKTyaDGR/1unOowkBqQZiC9/6jocoyQthoZauJR4KlvIf
         5RPQ==
X-Gm-Message-State: APjAAAWMbzkMPXvbghZbWd7NMMQyRu5hFO0ZHQ9AgTMpi9YrC7mbIHy4
        VNTT6qERaidtOZPYa3gpIP8=
X-Google-Smtp-Source: APXvYqxTY7WCj2xqd8jZnjpQFVhDqMsXc162OV4Ev36zk054hC0qFGnC4etgldMyVboC8w5Y9MBvNA==
X-Received: by 2002:a37:52c1:: with SMTP id g184mr11795366qkb.338.1557154279804;
        Mon, 06 May 2019 07:51:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m62sm5695639qkd.68.2019.05.06.07.51.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 07:51:18 -0700 (PDT)
Date:   Mon, 6 May 2019 10:51:17 -0400
Message-ID: <20190506105117.GB24823@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write
 functions
In-Reply-To: <8d14f3e0-4b95-900c-55f0-dfff30ae655f@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-3-rasmus.villemoes@prevas.dk>
 <20190503175732.GB4060@t480s.localdomain>
 <8d14f3e0-4b95-900c-55f0-dfff30ae655f@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 6 May 2019 05:57:11 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:

> > I have a preparatory patch which does almost exactly that. I'm sending it
> > to simplify this patchset.
> 
> OK, I'll hold off sending a v2 until I see how 1/5 and 2/5 are obsoleted
> by your patch(es).

You may rebase your patches now and add your new implementation of
register access through SMI in the smi.c file if that is necessary.


Thanks,

	Vivien
