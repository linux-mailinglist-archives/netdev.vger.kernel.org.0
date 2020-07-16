Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A2A2227B8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgGPPpo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 11:45:44 -0400
Received: from webmail.i2rs.nl ([159.65.192.235]:35746 "EHLO webmail.i2rs.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbgGPPpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:45:43 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 11:45:43 EDT
Received: from [192.168.178.8] (mail.i2rs.nl [83.162.200.97])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by webmail.i2rs.nl (Postfix) with ESMTPSA id 8F508FC4B2
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 17:38:57 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Jeroen Baten <jbaten@i2rs.nl>
Subject: newbie question on networking kernel panics.
X-Pep-Version: 2.0
Message-ID: <49a5eb70-3596-26b5-37bb-285bbdc75a95@i2rs.nl>
Date:   Thu, 16 Jul 2020 17:38:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have been working on a Linux desktop for the last 20 odd years.
Currently running Ubuntu 20.04.

Yesterday I enabled the option "Flow control" on my TP-Link TL-SG1024DE.

Subsequently I was forced to enjoy 3 kernel panics in the timespan of 18
hours.

After disabling the "Flow control" option my system seems to be stable
again.

I do have 3 sets of "cut here" text if somebody would be interested.

Please let me know if this information is of interest to someone or if I
am barking up the wrong majordomo tree.

Kind regards and thanks to all here for your immensely valuable work,

Jeroen Baten

-- 
Jeroen Baten              | EMAIL :  JBATEN@I2RS.NL
 ____  _  __              | web   :  www.i2rs.nl
  |  )|_)(_               | tel   :  +31 (0)648519096
 _|_/_| \__)              | Frisolaan 16, 4101 JK, Culemborg, the Netherlands


