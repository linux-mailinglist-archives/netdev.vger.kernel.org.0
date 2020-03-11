Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E2B1810E6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgCKGk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:40:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42652 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:40:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id v11so1051066wrm.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 23:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LHBD9s43OTBzZYYhj7/7qsjWzhdHeoXneVycwXq9UaE=;
        b=i3OLSzV/8BE9VFGp526LhyLncppXC1dAWnxia8LArMUC3W7Ij2MpETm+/aGePGLbrU
         0CGNqpT86x7JRG6e7egJ6FCQaCKPKEnxnSXMEQZBU/hcCL9Wddxu5TyrGEN84rY+nbwi
         OGNGBxktjDK76dgKMJ0uqz4cnx7mjAXoxwG/i4Y8HEzB1rXGsXVuKD4a+wLcM1ZegdAV
         0Z2oK3C0lAl/GzCQk1tPwK3dbiFDdMaFxaMS7cJuoyuP9bEjf9S1DlviJYVnh6/BjFUV
         imJczxkn32ED6jNYSQNEHXevFK9nn6xzkOUBrT+L1EVKWhWzEW3Yg6iIJ7q0lxCZcnOc
         hoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHBD9s43OTBzZYYhj7/7qsjWzhdHeoXneVycwXq9UaE=;
        b=au/j7EhPmPrK0oo/OBWEDomajBDmN/6Jf0I8Hd8W1XhWsarWZ8DVomgp0hs1OgHExC
         j3PUiFJOhGxPIiN7tB0luJqV6A6aSfQMC+1iYzV577lwmAXmxs2n3exwpbBpDW4ketjU
         bueEn13NkADD2FRDRcFFmeN8a8AKevmR0QtkQ4IpyoeV4pWBSc9pW/VeI5LekRS+Bcmx
         1Y/GAkO/bYL55U3gh60641JkRixrIiXDtUjV+RaxKBxEKM+EEjcOOzMVSbs2vZDiOHhc
         3xcFTN+9MhvpjdrER6+9qpf/2Inx62FeqB/1EEVAWxA3OhspKtkb216WBldqTpTPG4E0
         g24w==
X-Gm-Message-State: ANhLgQ1PQeBHNElP5rRcZx4B/CD5wodKlZVYnGFvrI1SMl5ejfqtMWnK
        v4UmVcB7w4Fo3VCrVCSp88ZdYGZD65qOhk3DBpQ=
X-Google-Smtp-Source: ADFU+vt5L0t4cFpzN1Jp8zsWFRoernE9AA5E5me9bqEEOy6J5XC1NROcjtjzHY+A0D/RFjDpf2xOhyUCVALhLwxCLQA=
X-Received: by 2002:adf:a4c4:: with SMTP id h4mr2459949wrb.112.1583908824840;
 Tue, 10 Mar 2020 23:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com> <20200310144551.177ddb0e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310144551.177ddb0e@kicinski-fedora-PC1C0HJN>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 11 Mar 2020 12:10:13 +0530
Message-ID: <CA+sq2CcqgV2SJY51O6Ve1v_mQX4aYOPY5fB1o=oduRPuXwPy3g@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 3:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Mar 2020 00:17:23 +0530 sunil.kovvuri@gmail.com wrote:
> > +static const struct ethtool_ops otx2vf_ethtool_ops = {
>
> Please specify .supported_coalesce_params
>

Thanks, will do.

Sunil.
