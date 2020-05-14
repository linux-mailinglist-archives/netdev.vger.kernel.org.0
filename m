Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF631D3170
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgENNiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:38:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D2BC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:38:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x15so1336082pfa.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M4kBWbCptX0r7KM8VZ7cOcdi26FjQODh5D9EJhgrt5w=;
        b=QtIj8l2Rco+1wVfmL1o6f8ckgMyCB65kvFaCoTs30tmkpsppasbheiixE1YlybQPMB
         5tqAcpk86JrjKa4mjdwSS22s/ySbJM4PktXJCm/NgeJjeLLNADBXy1XcTXN8FwYGs86L
         a2Rn63+zNr/myNHJD38MTL4cYnAtqmQxxH9gR7rIg/ZbcC9mvIalMKGqIZ5oLJ7aBmtG
         oCM3UUxQxQbc1q85V75GjO//Bt/5v0628lgJrQUR7n6vfZFSOLwb0SdQYg3dkGJAuA0h
         QaYzQhq/9pLQ1XovDg38iAf8x3on6KlODvTDlqRxLqSeJjNfgjHr5Rg8yOb5f5dZQK/7
         vqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M4kBWbCptX0r7KM8VZ7cOcdi26FjQODh5D9EJhgrt5w=;
        b=JV6Gd9G49YRfuEGKvhEsaMsUllQLiQscZZhPQvws10KDfHO1QutZNywtZa0+wg/o9Z
         wxaID17Sh2cZjJ+HS9RDxPGeK1xpSUEcFJB8mN8QexMUpxoGSAiOqlWisLql2Nd5qV+P
         HfeCm8Wk86M3nEUKS3Cmuj8B1htxnnZs93p+Kd/5ZQ+DrN1Orj9hWggexA7ON3vre/Yp
         X+9EyrHGoGaIHIKHFEWgYaNx6ZLY5JUqNlOOmUkwNO27fuYnoOJVEu15i5DuY76XWMdU
         Z2dRJfFsjH7Ub7S1g9xtwBDe7yk8PTbqklBE7MDdsfVHCUcNzKfv8jcHRXuKPQhus9yu
         DuqA==
X-Gm-Message-State: AOAM533RM5yUO//E0Hah/BbErkiXYxqcJ2zl7pSUNWAp3pnDKTS3HqHC
        OB5cdUsUET4jFtakNxRkJzQ=
X-Google-Smtp-Source: ABdhPJzkQpcI0RqhoFMF1IAq9kjhYaPoXyPxUApRqkPz65AS+fD3pkcDbxIRVLkYd1s+8mSDQt/PhA==
X-Received: by 2002:a63:ed02:: with SMTP id d2mr4124321pgi.119.1589463492096;
        Thu, 14 May 2020 06:38:12 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m4sm5125662pje.47.2020.05.14.06.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 06:38:11 -0700 (PDT)
Date:   Thu, 14 May 2020 06:38:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Olivier Dautricourt <olivier.dautricourt@orolia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] net: uapi: Add HWTSTAMP_FLAGS_ADJ_FINE/ADJ_COARSE
Message-ID: <20200514133809.GA18838@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514102808.31163-3-olivier.dautricourt@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514102808.31163-3-olivier.dautricourt@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:28:07PM +0200, Olivier Dautricourt wrote:
> This commit allows a user to specify a flag value for configuring
> timestamping through hwtsamp_config structure.
> 
> New flags introduced:
> 
> HWTSTAMP_FLAGS_NONE = 0
> 	No flag specified: as it is of value 0, this will selects the
> 	default behavior for all the existing drivers and should not
> 	break existing userland programs.
> 
> HWTSTAMP_FLAGS_ADJ_FINE = 1
> 	Use the fine adjustment mode.
> 	Fine adjustment mode is usually used for precise frequency adjustments.
> 
> HWTSTAMP_FLAGS_ADJ_COARSE = 2
> 	Use the coarse adjustment mode
> 	Coarse adjustment mode is usually used for direct phase correction.

I'll have to NAK this change.  The purpose of HWTSTAMP ioctl is to
configure the hardware time stamp settings.  This patch would misuse
it for some other purpose.

Sorry,
Richard
