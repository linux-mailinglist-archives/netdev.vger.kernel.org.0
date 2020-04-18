Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A781AE99F
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 05:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgDRDYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 23:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgDRDYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 23:24:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048C3C061A0C;
        Fri, 17 Apr 2020 20:24:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b8so2007399pfp.8;
        Fri, 17 Apr 2020 20:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BzICRuRvjPRdTPirDnTzrOCvzqk/XEDtlZnEDCIYLoY=;
        b=rjvdAzlZKp6w6jFqmhVeYNTx5/gXO78Z5vRQAOBCHGIedmsm2elEBEitm+SCF82de0
         wNCShDOZN4fbKSjPlK8hPQ95i9d7+RypUGG0rZ3jKMXkiHJjnioQ27BZI5lf7JSfXTyv
         VA2PzizITqrlX+WSNiNXR9Z3foy514oe5RUIPANGcTPgJHzr0QNlbS9vQdKFppWRsqyC
         acQ6Ut4HPVZ8SpgGgAXRCzccwlFIx7TYPgW6sAGcN3l9hTB3bHru4pjMYGdCRmxiKeOy
         ma4PxJ+z1g9cXvjiOFrTHvXsfaYDZn1Jt6DIo8STBp7c+A2ipguCe60FPMmc8eR08BGa
         dGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BzICRuRvjPRdTPirDnTzrOCvzqk/XEDtlZnEDCIYLoY=;
        b=rGVnYSPEA/1zBk9zXSawUWmZkQ+WNO/XCg8hlc4EWgsYQX2PdJuB3T1B81ccRapfBr
         GRyDTKyXQlmGGjCuRbT44+gyxZaTA/szCiOCYkicNr9sDH2nY87JetxmZD/OxaPGRiJn
         buNhLAASlNy3seTQSrI9l/AcXyGHIqj2W/gyvmOSQG7Ru6Xe8BaQNL2JtXNDqVXTdarI
         NMnwEu74lDyCzk8AuuX5hNvkaHUGf9u6gWfAApTriyV7pif5PqXSwleUz4ELtsGSCSIH
         Y5U+x2LqMJXqasT8v40TtZAOGSlGwAwlOW3TG+NKeHL9RCNp52IqV8PDiYfQmendfwW4
         hLHg==
X-Gm-Message-State: AGi0PuYJbPcNyc4TJiaHa0BDuuwNzfVg6UGgTiO+fZq9har243beAxQ+
        NT8qRWq4Dh/j4fHcyeR+JYI=
X-Google-Smtp-Source: APiQypIaI9zcregVywXTVg0wstUgRLl2Y1nF+aRzqE+UNWB4X8Pmj7nS8U8vgyfS/AbX5ck02DsoyQ==
X-Received: by 2002:a62:5c1:: with SMTP id 184mr6768393pff.68.1587180288477;
        Fri, 17 Apr 2020 20:24:48 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f9sm19573203pgj.2.2020.04.17.20.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 20:24:48 -0700 (PDT)
Date:   Fri, 17 Apr 2020 20:24:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     min.li.xe@renesas.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: idt82p33: Make two variables static
Message-ID: <20200418032446.GB9457@localhost>
References: <20200418020149.29796-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418020149.29796-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 10:01:49AM +0800, YueHaibing wrote:
> Fix sparse warnings:
> 
> drivers/ptp/ptp_idt82p33.c:26:5: warning: symbol 'sync_tod_timeout' was not declared. Should it be static?
> drivers/ptp/ptp_idt82p33.c:31:5: warning: symbol 'phase_snap_threshold' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
