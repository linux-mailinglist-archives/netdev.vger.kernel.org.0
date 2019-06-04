Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4C43497C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfFDNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:54:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43739 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfFDNya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:54:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id r18so6926764wrm.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6w2AucvjtDh+rZGQHXthYQfmA+FLv2Yd2qNByAdA6s4=;
        b=Qhr2DmOOCl8d6oGaeG9JGmxpygrHV6KMWLyWY7XMxYfaiszHAGu5iXdwsJMzeHIJUF
         YmrKTKZr7secdr2gO4BZGXBMFXu6mT2SkE9G87xGPscj+t/oA2ZY1BTOpsEUr4fBqUeE
         L8QByBd8qMk5HaT4C348ls+P1zIAlc0R15+gELT2OUZ6F4GaG13U6ofEyM9VvhbaPAmH
         VweGfRnqFtOQW6Aq8tvHSKetGGhKpM2I5rZ2nlZMsNZOLsvIia6fSmkj6OnQT5Rw0zBT
         Hcslv0ITKDU4wibY0HxNXo/x1Vj0D8wWzmVfgV6R1WDtOIBvt8SGrTLFydaEfmnHua4y
         IDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6w2AucvjtDh+rZGQHXthYQfmA+FLv2Yd2qNByAdA6s4=;
        b=YlBwucDpCPIMGpSXhyyC44eDZ8pqYh/X6V1+BulBeCaYLiljAEb5QwAZF8h4MRtvug
         JQNT100rcqz/UyVqAh0LIMB20K6lFuR3M5d8WnkJg6Kzv2qXvN88br/UG4INirnHcE4L
         iadLWojCIl23K/71G1dXDt9a4wHu6JF4PWpeC+vc5MHhPMwi1H1ZqkTMS1lxj27PoMxK
         fYKw9Revtc1rlh5N7lp+hpiIQwFuHBOZ6Vt+XNCEPvF5N0AaTi0sbFHdot8tVWl8boW9
         LvfvKPri1lGjKxNdiaS2i4Q1rUKytsAtTDHjAeOLgugVfCpiz5Jq01zPBzeU1uk9teAc
         1KyQ==
X-Gm-Message-State: APjAAAXynZicoZK9M4i92BTXuLOiFNmW4F0TyG4NRTrCy5SzSGiahtQM
        0axuy64Rwmt0Ahof8fser0cOi+aBCc2L7A==
X-Google-Smtp-Source: APXvYqyb8cy3q6aIdYnv3/h6DJAWTfNItvqPNQvkolKxuc0BuTNTSxwnOOoLvcM2OsTTwEGU+PEIhg==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr20299315wrr.70.1559656468501;
        Tue, 04 Jun 2019 06:54:28 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id c16sm3540086wrr.53.2019.06.04.06.54.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 06:54:28 -0700 (PDT)
Date:   Tue, 4 Jun 2019 15:54:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v3 1/3] header update
Message-ID: <20190604135427.GB3202@nanopsycho>
References: <20190604134044.2613-1-jiri@resnulli.us>
 <20190604134450.2839-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604134450.2839-1-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This and next 2 patches are aimed at iproute2/net-next. Sorry for
messing up the subject prefix.
