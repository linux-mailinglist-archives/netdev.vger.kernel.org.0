Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF02DFC2B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 05:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbfJVDV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 23:21:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41154 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfJVDV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 23:21:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so9716415pfh.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 20:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ob9DfPNA5qW/GNRoJuVqHjpe9O4E6pPnWp6/mZccG44=;
        b=lY6/yVAfbzUvMes3x1T7nbzVmZhalvu01uaKgK02a8/wWzVAPXSYgas12MQwvsn0Cy
         3set4yBnNbNL/ioQQk1F00AU9wSDptQaAZCBIiSAFNVRxYHw/MsF0kZg/0Kn4SFZfu85
         DggJ8fP08kL+RM3n/fLmCSycKlj2RyCQsT3lfT0O3MlMYAlHwLhGtwIy6/RvsegoDMo4
         Dn5x9y9i41vl6EcwvwEVo8qdTifu4MvINRtX0nGkJtePLrkkZWTLdT3RY5uqkrHiYp1/
         t67j8V8S+XQpHicRT0eStqxppHv/iBRTXVGEpekkMvzPgG6ObmCzwk3KzrqWk11+E1B9
         AzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ob9DfPNA5qW/GNRoJuVqHjpe9O4E6pPnWp6/mZccG44=;
        b=Td0EJRy2zHs3yxGdpPd3cdB0ArKoAgROibIMnFisK6dRk+0ivnfCahhbubhT193Box
         ag7gmZnNhwlq1jUL8KmeqhaHS2XiiUGKDRLuawxXXN53waz/+wv0s2EfyZ1LFrYXyIZf
         TMIPO1hEBMazlxcAiqQWp3s6h87QkOcSyXak8XtumWgC4oDvVrDJVkWE+4ETCExPRURl
         7ywtkogOmHo4t3ZBT1G/IlHq9TjDFZlvdH+TPeq/ulvpkVZ85sRCgkhJzUHC6CTpjLZM
         dvEcuSMvPPiOdYK+3gtQT8bFqFhFZ2iE5fwkeOZQNRAjMSbdK5aNBYFHtxQzzYmxUl85
         X4Sg==
X-Gm-Message-State: APjAAAVgtpf7c3F5fszeClfSuJAzs5nnSm0XpLTK8FJtjIhcUba4bRPR
        994rfcRLI2eBP5iEfnxGnc0GLA==
X-Google-Smtp-Source: APXvYqy4qcwkCoemmHbJWnQOoFLZi/aQDQFp6y5pVUo/DM0AWXZ6Ae4ruNf2rVXG6uPHgnHuvKLhKw==
X-Received: by 2002:a63:4654:: with SMTP id v20mr1318259pgk.11.1571714517835;
        Mon, 21 Oct 2019 20:21:57 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z23sm14482635pgu.16.2019.10.21.20.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 20:21:57 -0700 (PDT)
Date:   Mon, 21 Oct 2019 20:21:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v3 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2019-10-21
Message-ID: <20191021202154.2136da28@cakuba.netronome.com>
In-Reply-To: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
References: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 11:01:38 -0700, Jeff Kirsher wrote:
> This series contains updates to e1000e and igc only.
> 
> Sasha adds stream control transmission protocol (SCTP) CRC checksum
> support for igc.  Also added S0ix support to the e1000e driver.  Then
> added multicast support by adding the address list to the MTA table and
> providing the option for IPv6 address for igc.  In addition, added
> receive checksum support to igc as well.  Lastly, cleaned up some code
> that was not fully implemented yet for the VLAN filter table array.
> 
> v2: Dropped patch 1 & 2 from the original series.  Patch 1 is being sent
>     to 'net' tree as a fix and patch 2 implementation needs to be
>     re-worked.  Updated the patch to add support for S0ix to fix the
>     reverse Xmas tree issues and made the entry/exit functions void
>     since they constantly returned success.  All based on community
>     feedback.
> v3: Cleaned up patch 4 of the series based on feedback from the
>     community.  Cleaned up a stray comma in a code comment and removed
>     the 'inline' of a function that would be inlined by the compiler
>     anyways.
> 
> The following are changes since commit 13faf77185225a1383f6f5a072383771ccfe456b:
>   Merge branch 'hns3-next'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks!
