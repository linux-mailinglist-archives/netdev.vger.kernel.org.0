Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297C698249
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfHUSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:03:55 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:45683 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHUSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 14:03:54 -0400
Received: by mail-qk1-f170.google.com with SMTP id m2so2613420qki.12
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 11:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J7rYA6BruoIuXSWla3jWz5ix8+moVKkrs3lgi68Wt2g=;
        b=x67Kf+az8bh84T2OrifgUyRsvWEuJ1Nn03yTqWYZKpNn7aFAjwvT+uKdV5VnBiZ4j8
         ZnRXKKDTmjRrvPVQASglwhdqUQaIwDM7UWNG3Tj+80MwnmiXFxjf/+N1k/kK81caS8O0
         8i3w/48g/8IGZ3ZnR1RkaHLwCfWJu667H4UcPVhLx+cqrqPqdRmGstC3csNE6A+tGVwa
         NmBSEs7cQHuNuEiqWp2R576DvhIFuI9+zoY4PdID7ZAhX451EByex10hlH6QLwJ6uiNS
         XHSQdcm60hhVjsi9SiF7CwpUmqYISgeoBz+8gxkbh+PIdtelJmDotAJQ8dxkkVjloBC0
         DDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J7rYA6BruoIuXSWla3jWz5ix8+moVKkrs3lgi68Wt2g=;
        b=WpTc+OR9hEN/nx2EPAQqx57/560NQqxQUE/s7sNPkPhRApF5OzmdR7CDbcUANSIOJg
         UEIY/UA8dDvkEt+dHvKFgtfjMYlGcFzDojp512YPz1Kb13mbN98adrLdr9z3LNe2iTE1
         IrRhOiAr1ijPTKj+cPOY4o+EC3gdUZF5oUEqIHRN/iisc6FwO7t7M/S0Vg4K2jYr2rMU
         h3pMgRr6jijt+/UK9ayLPmL1w32mitDk87GL3gfdm81ciYUu4RmASXQGxW7l/iLNNvx5
         W4oSFw+rbDZcRxqsED2b76tf/n+CFUJ+e4uVpUgQ5ktlGwIdVExrpx3c/4NFhuCuL2lq
         CtKg==
X-Gm-Message-State: APjAAAX99u/ERqpOly1/OoGKY+6JKUUR4kyTTyERSCRrzfaZSK+s6foq
        ENvhTfx/7kSvd5sF+Jsneyj1X65/0Zw=
X-Google-Smtp-Source: APXvYqyCJcsla5sqK13L9KlSNDLDyMi1IBLXdbhjzt6HAk5tdwdZgmgqOM7HjjM3MfymPGER8a7dVQ==
X-Received: by 2002:a05:620a:632:: with SMTP id 18mr34273012qkv.205.1566410633362;
        Wed, 21 Aug 2019 11:03:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 1sm4202072qko.73.2019.08.21.11.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 11:03:53 -0700 (PDT)
Date:   Wed, 21 Aug 2019 11:03:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: various TLS bug fixes...
Message-ID: <20190821110346.449c5612@cakuba.netronome.com>
In-Reply-To: <20190820235112.2b5348aa@cakuba.netronome.com>
References: <20190820.160517.617004656524634921.davem@davemloft.net>
        <20190820172411.70250551@cakuba.netronome.com>
        <5d5cd426e18be_67732ae0ef5705bc4@john-XPS-13-9370.notmuch>
        <20190820235112.2b5348aa@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 23:51:12 -0700, Jakub Kicinski wrote:
> > If you have more details I can also spend some cycles looking into it.  
> 
> Awesome, I'll let you know what the details are as soon as I get them.

Just a quick update on that.

The test case is nginx running with ktls offload.

The client (hurl or openssl client) requests a file of ~2M, but only
44K ever gets across (not even sure which side sees an error at this
point, outputs are pretty quiet).
