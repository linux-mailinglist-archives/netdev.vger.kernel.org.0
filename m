Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694A394C4B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfHSSDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:03:50 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40565 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbfHSSDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:03:50 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so2181669qke.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 11:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=HWet5grM2v9qMQDu6E65Bu0yNLTBB1SYEyz+yP/9R6A=;
        b=JxCD1zBw7HSSfA+p40wIa5AwDgt0KtbuteYIlK18wISgPt72Z1qakwZMQp8qcu4LRR
         CXJAVwno+O2BmsjUfS/25FebU8cEHpV/M/GzyjrNdRKaCTgLLu+KGfZp/n39pnrD42M8
         Zc7B+MP6BcZMuiu0WEUskno/hSr4ZkBFM91dIWB30HykdhOmUV/XZ8FKukOSMR88nI/6
         77VSfBK3iAijLfGyiYUEWyMASwNQ6Sql9+1CNnxsKxaQIdC/xBYNaD4rkE2E7YGAFePG
         s4PsdhMo6qownGwWvdWLD4eJWqh3VEDJLLgRlDf1gOJRvBE60/RT64AV1fcYSz6/kb8b
         fVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=HWet5grM2v9qMQDu6E65Bu0yNLTBB1SYEyz+yP/9R6A=;
        b=eSKt3Ckq0CHW1HB9nvQ0KFD2gh7U91MBys7PyWe8t/YlIurmpUV/AgRF1rIyemLRcK
         +Aq/gn/m5eL3oQ/1b95e/XHK9K0mLNwUy+ajzdK6bBL1TlVSTK3/o4SBPIzocSWI0kqi
         7soGFjBa9+VV28dnKF/5sblEe4Rw4HvUDEPuph9PU/cJB/ydcde+BVuAFGEBQO7dJffS
         gebBDM9XVKJD/zmGHtVdPppq/XSZq/sAlI9kSPpvdT6GGJpHHhWaNt/k70kuThnn4BjP
         l3NGaeJCLoSRHU10U6ak7TEMpyevt2Ds8BzfCWR2aSxM1dLRmawup65szcKlE3DczekE
         l9Og==
X-Gm-Message-State: APjAAAWejMf1ICTyOFR/1ltIUWNRBY91GgBQg/vEONdGViVQq37Vbths
        MJwFeXRQnDSn5gbvwgCbo3E=
X-Google-Smtp-Source: APXvYqxFqNyrJghQvbmEGwvJuKDU8si/UZ2inkmz9NuxJSyXGhjDhcKmndZElpFss5xGLo3jjwFVlg==
X-Received: by 2002:a37:9ec6:: with SMTP id h189mr21659739qke.280.1566237829538;
        Mon, 19 Aug 2019 11:03:49 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z4sm7170363qtd.60.2019.08.19.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 11:03:48 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:03:47 -0400
Message-ID: <20190819140347.GB1227@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 3/6] net: dsa: enable and disable all ports
In-Reply-To: <20190819193246.0e40a1d4@nic.cz>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-4-vivien.didelot@gmail.com>
 <20190819193246.0e40a1d4@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, 19 Aug 2019 19:32:46 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> > Call the .port_enable and .port_disable functions for all ports,
> > not only the user ports, so that drivers may optimize the power
> > consumption of all ports after a successful setup.
> > 
> > Unused ports are now disabled on setup. CPU and DSA ports are now
> > enabled on setup and disabled on teardown. User ports were already
> > enabled at slave creation and disabled at slave destruction.
> 
> My original reason for enabling CPU and DSA ports is that enabling
> serdes irq could not be done in .setup in mv88e6xxx, since the required
> phylink structures did not yet exists for those ports.
> 
> The case after this patch would be that .port_enable is called for
> CPU/DSA ports right after these required phylink structures are created
> for this port. A thought came to me while reading this that some driver
> in the future can expect, in their implementation of
> port_enable/port_disable, that phylink structures already exist for all
> ports, not just the one being currently enabled/disabled.
> 
> Wouldn't it be safer if CPU/DSA ports were enabled in setup after all
> ports are registered, and disabled in teardown before ports are
> unregistered?
> 
> Current:
>   ->setup()
>   for each port
>       dsa_port_link_register_of()
>       dsa_port_enable()
> 
> Proposed:
>   ->setup()
>   for each port
>       dsa_port_link_register_of()
>   for each port
>       dsa_port_enable()

I understand what you mean, but the scope of .port_enable really is the
port itself, so I do not expect a driver to configure something else. Also,
I prefer to keep it simple at the moment and not speculate about what a
driver may need in the future, as we may also wonder which switch must be
enabled first in a tree, etc. If that case happens in the future, we can
definitely isolate the ports enabling code after the tree is setup.

So if this series meets your requirement for now, I'd keep it like that.


Thanks,

	Vivien
