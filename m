Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7874C66BE55
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjAPM4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAPMzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:55:35 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A781CAE5;
        Mon, 16 Jan 2023 04:54:12 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id B30961668;
        Mon, 16 Jan 2023 13:54:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673873650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCVU84HMNiOucaz5S8RZ1A8WCK1MR21DEmlB7vu3qkw=;
        b=IYWYcXVD0ID0v6yQLsHQjRmHSe2UbEUlRUQpic7Kma+4d5VBdkNzbdyYFIGA2r10FdXuMz
        +rITzS+VT5QbeKWlQp6Nqx3bwL2XTf9+LCtxLosWq+ugkK8EOHHHHB+cR3gV+KqsiatGn+
        xfrQk4A6Ul5fuo7WDxgycU+DHbdaP3Kskth+hsgr+0l8Z1g2HqZXUnPxYK3C9LSB2o66y5
        n3CkHZKnA6bZFQj/aqIEDR26/52WnYiyM9nBE8mUSNSBJ7OvOev26TuzcvkoBmzkG648bL
        sym1pj1oXP3V4zn+xwUtup3E5EiadyGvgb0rw7Rz7KO2UzmtqootQAGRHQIw+A==
MIME-Version: 1.0
Date:   Mon, 16 Jan 2023 13:54:10 +0100
From:   Michael Walle <michael@walle.cc>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write} for
 new C45 API.
In-Reply-To: <Y8VIFexsNpJiRG11@sirena.org.uk>
References: <20230116111509.4086236-1-michael@walle.cc>
 <Y8VIFexsNpJiRG11@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0270375b121631fdca30b75e4a839cb3@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-01-16 13:50, schrieb Mark Brown:
> On Mon, Jan 16, 2023 at 12:15:09PM +0100, Michael Walle wrote:
> 
>> Mark, could you Ack this instead of taking it through your tree,
>> because it future net-next changes will depend on it. There are
>> currently no in-tree users for this regmap. The Kconfig symbol is
>> never selected.
> 
> I can just as easily send a pull request for it?

Sure. Just thought the former was more convenient.

-michael

