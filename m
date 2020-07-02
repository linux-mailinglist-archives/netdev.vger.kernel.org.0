Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70F21263D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgGBO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:26:30 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50980 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgGBO03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:26:29 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by linux.microsoft.com (Postfix) with ESMTPSA id 02C8920B4905;
        Thu,  2 Jul 2020 07:26:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02C8920B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1593699989;
        bh=P3UXhidaXo7NGcfgd6p/wj7UCpxsC138EMom+wcKjTY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SPhLhUq/ETVh+Bd09Dq2JBtPAOgzxLnXxsAOwOf9qDLe0Fu1/18GhRnx7wovCugvE
         yAo2Cf2Vftv4+9V+hmlKs9Lryz9LPXiCD1cWW5lTZcfkGtgS4o86jxM5PCGsPR8eXg
         +9D+XK0uZJc1nmMAt3IMrZiXOByX4Oqhj162JxZI=
Received: by mail-qt1-f172.google.com with SMTP id j10so21329271qtq.11;
        Thu, 02 Jul 2020 07:26:28 -0700 (PDT)
X-Gm-Message-State: AOAM5311xdbmsSxz/joY4HxyaAx9+qYR6rcqSQn9bw0G/sQczCgbg4ZL
        z97AaCCB6N5GMFim9ytvrnxTdsMIRhxYkEFuiKw=
X-Google-Smtp-Source: ABdhPJwOUUWGBD2LigZrLWPlWB8g27W/V6HggrhFUPdcrIDn8kQg1yeCIZjJ+h5oLq5UqJIVJ/njeJplu9Uvn4j8pj8=
X-Received: by 2002:aed:2492:: with SMTP id t18mr32122419qtc.353.1593699987639;
 Thu, 02 Jul 2020 07:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200702141244.51295-1-mcroce@linux.microsoft.com>
In-Reply-To: <20200702141244.51295-1-mcroce@linux.microsoft.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 2 Jul 2020 16:25:51 +0200
X-Gmail-Original-Message-ID: <CAFnufp23ggXtC5pkT57JQ5Bp9vzLyWbFwe_h3W63J1jh4njZVQ@mail.gmail.com>
Message-ID: <CAFnufp23ggXtC5pkT57JQ5Bp9vzLyWbFwe_h3W63J1jh4njZVQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] mvpp2: XDP support
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 4:12 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
>
> From: Matteo Croce <mcroce@microsoft.com>
>
> From: Matteo Croce <mcroce@microsoft.com>
>

DUP! Sorry.

-- 
per aspera ad upstream
