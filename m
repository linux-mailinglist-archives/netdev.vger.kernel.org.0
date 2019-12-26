Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9873812ADDC
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 19:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfLZSRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 13:17:02 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33823 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfLZSRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 13:17:02 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so23859568iof.1;
        Thu, 26 Dec 2019 10:17:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gx5/mxf2OcyKOraLNib62q7dUwuhxVBq/hiHG9gDOK8=;
        b=pk3SukjcL9lz9I+NLsAD6xSDkIh+l1BHtMPeVLjbD8W0lyUg/2JEXVdlQuh2Eo8yxZ
         Ya8lzJGMORbtvzItMFvPYj/lMFJd6/vIcbV4ItCRyt734HPHLlLRJ/fbCe6ZbI/vpiSV
         GASX2lR1jmWqBTNkMwcvO0T1Fo8uXiRkNwHXP6C85EhHShUbdwiTgUTwFLGy79Tkz8E3
         P0Y9vmH9KbWgm0ANYGWFRTuC4dI5O+R/kiS9BZ+V/t2n6uEpicu+mDh3Oq7JfF/nU5dp
         R8dy6QPpEk3Ary429LMUG8RmOf2GtNPE9uukqPXv6wJe41wD368GgDugkjOeR+QqrLuv
         fJjA==
X-Gm-Message-State: APjAAAX17blroC4aV+OpYhkH7VCv6cz2A/eeN59J8C/MXN4FLlnVquU7
        f6WyZHJ5r5+4k4aP8zED1dci080=
X-Google-Smtp-Source: APXvYqywCS38qHT/w3F29zB4n5zSCbDc7ESbj0sPmDiuvsMs6M1VwKhBVvcGbNbgh5Juegluk0s9vw==
X-Received: by 2002:a02:81cc:: with SMTP id r12mr36440392jag.93.1577384221519;
        Thu, 26 Dec 2019 10:17:01 -0800 (PST)
Received: from localhost ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id c3sm8768833ioc.63.2019.12.26.10.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 10:17:00 -0800 (PST)
Date:   Thu, 26 Dec 2019 11:16:59 -0700
From:   Rob Herring <robh@kernel.org>
To:     pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        wg@grandegger.com, davem@davemloft.net, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
Subject: Re: [PATCH v3 1/6] dt-bindings: vendor-prefix: add prefix for Czech
 Technical University in Prague.
Message-ID: <20191226181659.GA7471@bogus>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
 <af3f3bef1a82dff51316fdbcba518e5658808ed8.1576922226.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3f3bef1a82dff51316fdbcba518e5658808ed8.1576922226.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 03:07:30PM +0100, pisa@cmp.felk.cvut.cz wrote:
> From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> 
> Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
