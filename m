Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036EA449F9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfFMRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:54:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40047 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFMRyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:54:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so11373538pgm.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=babayev.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=NbtgBFNRjapeV7XwkkOgD05mL4VUy7Y9ZUCxRxVNsds=;
        b=SmteWydlDNz3KP2yLordqEQPllb6c8yoRGXU/vCkKFLYVVGRIKLhwz8a/jlM+M6yN8
         cQT/siSuukJCgOHrZYp/m6tNMZjN0SztWpbUpUlBm0VkgCKFTaRt4rFLzj9xD/1dBnRH
         n6KIMJimpDWWcyNP+FtnMyMwjrvEjO46YVCxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=NbtgBFNRjapeV7XwkkOgD05mL4VUy7Y9ZUCxRxVNsds=;
        b=MnLyyq+yKSZwK0fZAlbfvWuUGIDnYWJd6TlNwv1++uP+Hecn6tWZ091PEPq6yiKuLt
         IeDgyn7496nbVdQ58ZjPB+aPl7pHVEsIwregO6ybhhXMVG4FwN6dAA/e9zT9/pVPBZTE
         7CpRXiylhhUioXGXFyOu5WpdPLNuwPKmEcsFX/wdKFKh3i0p3qVLOnJkynzUlhFzDlaf
         SbKEQYg/j/IQWEjOCm04YvdMXybAWHUm5rZNBQJtJHoPmnUsuHZc5V8FkmI3Fz91dh8+
         IjLNKQxHwwxVuvny2Yk6/VWdktEzcKAFlJb/SImWZQ7HO6dxFIdsXCTxh8Wa4JFYYkIK
         WUIA==
X-Gm-Message-State: APjAAAWtrpjzX57LleZxWynKdd9ONIFyR97eRm3Hfn3My3NNR3xrxNkJ
        mbmSyr44PwtqHTFOV3NcGinuieNikh3oelBK
X-Google-Smtp-Source: APXvYqxTH3uAS+kmQajroEyFVVfbiTZJmL46A/FfpP+b7ES0UhN2/WJHP71DUtnWI0I+69ErmdQzOw==
X-Received: by 2002:a62:ac11:: with SMTP id v17mr32157513pfe.236.1560448476115;
        Thu, 13 Jun 2019 10:54:36 -0700 (PDT)
Received: from localhost ([128.107.241.189])
        by smtp.gmail.com with ESMTPSA id p27sm338705pfq.136.2019.06.13.10.54.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 10:54:35 -0700 (PDT)
References: <20190613065102.GA16334@mwanda>
User-agent: mu4e 1.0; emacs 26.1
From:   Ruslan Babayev <ruslan@babayev.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Ruslan Babayev <ruslan@babayev.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: sfp: clean up a condition
In-reply-to: <20190613065102.GA16334@mwanda>
Date:   Thu, 13 Jun 2019 10:54:40 -0700
Message-ID: <87pnnh9xr3.fsf@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dan Carpenter writes:

> The acpi_node_get_property_reference() doesn't return ACPI error codes,
> it just returns regular negative kernel error codes.  This patch doesn't
> affect run time, it's just a clean up.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Ruslan Babayev <ruslan@babayev.com>
