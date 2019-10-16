Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD9D97D6
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406443AbfJPQsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:48:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36190 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404582AbfJPQsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:48:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so15084136pfr.3
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=w6dM2VbPEtO+/3emEZ1UX1mMaJIyL16px2CSFIbD2Ts=;
        b=HHPkb20G4mb07e5D2EooDHkr2/ShR1MgxQElGs8DZXAHqvJ9mW0eAH6vL2u4GmxI1n
         75wrhZ0NdJJ4b80X46boRX0uYMK2idLD+FpFncOqdf5wdJyupml8z/K2tzBq2IMWo5f9
         lYEya8Pm/UK5ReKaQGxle+qq5WIL2vMMKvy+V8aEb5Ubot8JpvQw3kDb1cbR5JXsA4Z3
         gxTuaxhxyou7086VVMBMt+spgyj2iV/0OiA4gZk7+VjUSpaVXpt02/I5nYUBoEMX9uJi
         WV/VWuomCh2+pDoleArjQsLc+pTmZIO2G3PhKz4AgfSBi45pQN8uDG5YNDYofd74Rx53
         K44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w6dM2VbPEtO+/3emEZ1UX1mMaJIyL16px2CSFIbD2Ts=;
        b=kTaPGw8RVTyWoxfNFfKmbj5uAbWezVZWNTHKUSPIZyH6+9QYKyzQs61vKW0SLMg6zY
         4Q6il8KSaROSQfoZlfYaebdjvmHi6uhgEg7DLekswAK50DIQ5QYV5Ht1H5e+TTtsc4m9
         K5dOYImbgYzVF3fYbQik3QBRe5frTDvHcwK4oXoNRSFUoG5cdG/Cf3r79IkLDzaMtMKJ
         +EoR/0MQ5EopCtRAdmDEgZ4tBpDJy3JJsEpSoOVDoXcxoZ5axb7lE6fmrrIE7EYuh6s7
         0LMaDZc4nmdSw3zGv7OWu2AGkdKGQFflcm/IjXEVTqijgNHZ11TllcLeksHXqrqEVzON
         1rLw==
X-Gm-Message-State: APjAAAWWfDk4f29NuonMbun8f/kTdNUb06oLTNFxM5J5Y67c9oUWPAoc
        blSjJeUT2n3Noip6y1U92ag0jzMiXtk=
X-Google-Smtp-Source: APXvYqzuEgNbV5kzX9Nue302CtLae4gDoKCYTSI9tfdj9J2fmhmr8bFe3c4/er2a7J7Spnk+owhQig==
X-Received: by 2002:aa7:96ba:: with SMTP id g26mr9249552pfk.132.1571244531978;
        Wed, 16 Oct 2019 09:48:51 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q15sm23403875pgl.12.2019.10.16.09.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 09:48:51 -0700 (PDT)
Date:   Wed, 16 Oct 2019 09:48:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net 0/2] dpaa2-eth: misc fixes
Message-ID: <20191016094848.19bfb411@cakuba.netronome.com>
In-Reply-To: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 10:36:21 +0300, Ioana Ciornei wrote:
> This patch set adds a couple of fixes around updating configuration on MAC
> change.  Depending on when MC connects the DPNI to a MAC, both the MAC
> address and TX FQIDs should be updated everytime there is a change in
> configuration.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
