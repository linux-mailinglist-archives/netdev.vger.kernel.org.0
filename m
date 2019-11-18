Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45906100610
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfKRNDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:03:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32854 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRNDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:03:07 -0500
Received: by mail-wr1-f65.google.com with SMTP id w9so19404166wrr.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 05:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wv9tG/7LquXcsfhuek8p/vKB+glErzAx7gvb6JwF85Y=;
        b=ZX9zQDGBn2JIDwPhEjQZPCZo4oM9gDtjoTAry/ghnFVvbkrV+6nhvRoNjM+y908OjM
         IYb8fsdFV20LQ6BG+lYOR3DFjbD4LokPBdKA9tKaeFmWPZ4nv+53capt/CRQ/kR6A4Ww
         qiQgyKa+/wfmWdw9a3nn/oBmzSSLoZCXCVdlsjeFFavfKYcvJGBHz2M7oHrmpfECGFnN
         PkN0y6OzqE0+47faGpDfTmt4nFMXDKnki72S/awlN995IJZKIRrX1N8XHygaEFAxJUoP
         lTdmbPHLbQSWNIJ4frpMe0HB3vILa3eCq8U63RRfzgl4RpCytZbK7wAoCpzfHR1UMkOm
         I0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wv9tG/7LquXcsfhuek8p/vKB+glErzAx7gvb6JwF85Y=;
        b=LoGGqZVDgVW/u3q09rlGqqOo8cYoqdvDXAmH5g8WXPdGZjW722vr5e1yxdH8diiDEh
         oAP/l7Nm225ZkBkFtsEWDPzwTFT9oFCT+H1xOifr7zUw5Hso+KvcnK4ht7l3E6CpPeNN
         ffERq8bm7TRPnh7wZaHExgzX54GwLVitr98wVIYQ484rIXNXRCa9+EIzMC2i8oVHeRFo
         MO7Cc5q9cwL5juCjdGqowvVnZgSzMxO5bKCwM4qJaNnIey02Q9Wb1JZJqL2yPy3XUORm
         gf0idrlmDWTnWK1PoOfIhpCrWueAqAWl8cTKFVPzBrBsvYYkJlyNtxHAVVz1YlldQOMu
         j69A==
X-Gm-Message-State: APjAAAVHvgNnqsaeQAI7b5RkDKNmS4rICHJFwe8ow8wTF8Q/DdfYri6+
        /c4BQicoxIcZbAHK4N1gCrDH0g==
X-Google-Smtp-Source: APXvYqxybNyYUoW2Dv9Z6Tn1FkSqETHQDaMJ8+zeUEc3vlIp9fhRIWQS1Dg8MwDTK9PmZefsvvNF9w==
X-Received: by 2002:adf:e885:: with SMTP id d5mr17580513wrm.117.1574082185336;
        Mon, 18 Nov 2019 05:03:05 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id y17sm23782198wrs.58.2019.11.18.05.03.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Nov 2019 05:03:05 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:03:04 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next] lwtunnel: change to use nla_put_u8 for
 LWTUNNEL_IP_OPT_ERSPAN_VER
Message-ID: <20191118130304.ejmg73sld7yusdrm@netronome.com>
References: <60ad49e50facc0d5d77120350b01e37e37d86c57.1574071812.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60ad49e50facc0d5d77120350b01e37e37d86c57.1574071812.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 06:10:12PM +0800, Xin Long wrote:
> LWTUNNEL_IP_OPT_ERSPAN_VER is u8 type, and nla_put_u8 should have
> been used instead of nla_put_u32(). This is a copy-paste error.
> 
> Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

