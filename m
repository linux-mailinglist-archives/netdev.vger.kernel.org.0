Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C422F886DA
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 01:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfHIXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 19:20:49 -0400
Received: from lekensteyn.nl ([178.21.112.251]:47265 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfHIXUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 19:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=6APAfBHR3fK9TP76TpkiaRQRTEUbRsXbffX4Q7vJC1I=;
        b=U/wBjuTegmKHKER0lil9F75jaRcdKEMOOHYmF/W6r9JxvPvFjG1zCKF77Aq6BNavbw2gnFwRsPRGNnZVsLSFPRV8NHQZ7NO0wFRGgQCdHP7y3TcWSqrpix7M0g5SQf06asGWx1O+PEMDvVrIm8hKMc6knNBV8ymyU8CwRF3zbN0YDVUNARkzg3+OLQAbna8QKlvo4/H+05K2t9aF2tZ+4cbR1YIWkv7VHRGxDz1uxZ1p+W2eOWzyyWihWDH9s+CWHUR1Vw6OhoKjphuIpmiyUJ5irV5nZ4Kocgwu8ii2vyEC+LmH+z+wy+/UEfs3t5ouQtqcPD/hUhYmxRKnggRpng==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hwEBg-00073d-0b; Sat, 10 Aug 2019 01:20:44 +0200
Date:   Sat, 10 Aug 2019 00:20:42 +0100
From:   Peter Wu <peter@lekensteyn.nl>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190809232042.GA26522@al>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
 <20190809153210.GD2820@mini-arch>
 <20190809140956.24369b00@cakuba.netronome.com>
 <20190809214831.GE2820@mini-arch>
 <20190809145726.2972fa7a@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809145726.2972fa7a@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Thanks for the lovely feedback :)

On Fri, Aug 09, 2019 at 02:57:26PM -0700, Jakub Kicinski wrote:
> On Fri, 9 Aug 2019 14:48:31 -0700, Stanislav Fomichev wrote:
> > I'm just being nit picky :-)
> > Because changelog says we already depend on -lz, but then in the patch
> > we explicitly add it.

What I meant by that is that zlib is not a new dependency since it is
already a mandatory dependency of libelf which is currently marked as
mandatory dependency in bpftool. That is why I did not bother with
adding a feature test either since it would be redundant.

Adding an explicit dependency helps if you want to build bpftool as
static binary, or if libelf somehow drops zlib in the future.
-- 
Kind regards,
Peter Wu
https://lekensteyn.nl
