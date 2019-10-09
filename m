Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35CD1B76
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbfJIWOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:14:05 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41046 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbfJIWOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:14:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id p10so3720876qkg.8
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4LHadHMFTI2WEqehauhtH9JvVoooBz9Rp/ppLKbyl2U=;
        b=S6G1XuCl4MWpQUOT+VDZLYbAMkw7KN0fxfylNNuKuthY4rtFmlPV3lnvcjx6/v8+Xd
         R0PX7viru9RUfOk+DpK8vNneT/Qpc+g9NFYjMho1dIG4vh+7jRvPRhRq47CEv/Phh8yq
         hWqmNCAR9RXPVpraEqZq6P9kVCcEoh9FiWXwHDDjlFi4ATLuIu+IPSxgh5K8ZPI6u8bO
         m9fklHq/9EPmiO9M3MTIrVP+2Gx/eqsOUyK2IToD7oC7h0RgesuEkbqDRD0JYQKpim11
         cOxd0hve/BbpkEp2ngSQMrkakEkZKPtFwcduthXkCdeLL5gxuC71q0UtndyJam2Cyhs6
         Ltng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4LHadHMFTI2WEqehauhtH9JvVoooBz9Rp/ppLKbyl2U=;
        b=I13deQ8xO2EZU4FM2Epce241K6f+KZ2W3BpVJpQeU9qGeWNFuWuuVG8utqt5gA6OCt
         Qfrqof6puvP0DoFj3LfFKUeCRXVDZXMTcBVWW9HhrMSdQPBO6cKcf2lbBImDSjZ/oCft
         mgNPFTkUB6Yo6CI+IXo04PaHsUUsDqGM/gaCqfC8mpudyYrMBt+LU8IjgfXOZImFmX5r
         YwdB4TsfEbLjXqN0j+/w+L4vD/dXsZ//rbWLey2EWl+VCTAdiL8VDekpYzB6141oCl94
         znBn29k6JrI9+Oz2PDki08d5FqXYt0/1O+GuZW6G7mmiTUsLnK0F7nArQscKIpiElvaf
         JWCQ==
X-Gm-Message-State: APjAAAUseiZ76/vAdbPh6F6frMi+ll5Gmum1sHrzcBmcett4Ye29K6/h
        +EF1uClFfMB1z7HLd/pzqvkVIimtthA=
X-Google-Smtp-Source: APXvYqwsYTtqgYvtY82dQnmPw8qlnqlgoIrRvsIQUKnzDmlw1kqQPCZ8ldac14ydx/pSWtZg76No5w==
X-Received: by 2002:a37:396:: with SMTP id 144mr6078577qkd.479.1570659242836;
        Wed, 09 Oct 2019 15:14:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2211376qtb.2.2019.10.09.15.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 15:14:02 -0700 (PDT)
Date:   Wed, 9 Oct 2019 15:13:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        linux-spi@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: Applied "spi: Add a PTP system timestamp to the transfer
 structure" to the spi tree
Message-ID: <20191009151348.2e2e2383@cakuba.netronome.com>
In-Reply-To: <20191008164259.GQ4382@sirena.co.uk>
References: <20190905010114.26718-3-olteanv@gmail.com>
        <20191008105254.99A6D274299F@ypsilon.sirena.org.uk>
        <CA+h21hoid_bQ37qC30fDt62ces40PwSQ2v=KHTGkadV_ycrd5A@mail.gmail.com>
        <20191008164259.GQ4382@sirena.co.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 17:42:59 +0100, Mark Brown wrote:
> On Tue, Oct 08, 2019 at 03:58:51PM +0300, Vladimir Oltean wrote:
> 
> > Dave, do you think you can somehow integrate this patch into net-next
> > as well, so that I can send some further patches that depend on the
> > newly introduced ptp_sts member of struct spi_transfer without waiting
> > for another kernel release?  
> 
> Ugh, it'd have been good to have been more aware of this before applying
> things since I put them on the one development branch (I used to make
> more topic branches but Linus doesn't like them).  I've pulled things
> out into a branch with a signed tag for merging into other trees:
> 
> The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:
> 
>   Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-ptp-api
> 
> for you to fetch changes up to 79591b7db21d255db158afaa48c557dcab631a1c:
> 
>   spi: Add a PTP system timestamp to the transfer structure (2019-10-08 17:38:15 +0100)
> 
> ----------------------------------------------------------------
> spi: Add a PTP API
> 
> For detailed timestamping of operations.
> 
> ----------------------------------------------------------------
> Vladimir Oltean (1):
>       spi: Add a PTP system timestamp to the transfer structure
> 
>  drivers/spi/spi.c       | 127 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/spi/spi.h |  61 +++++++++++++++++++++++
>  2 files changed, 188 insertions(+)

Thanks for the branch, I pulled it into net-next, it should show up once
build testing is done.
