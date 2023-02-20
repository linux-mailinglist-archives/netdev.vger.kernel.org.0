Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F303069CB98
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 14:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjBTNHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 08:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjBTNHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 08:07:33 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAFA1BACE;
        Mon, 20 Feb 2023 05:07:29 -0800 (PST)
Received: from [192.168.1.155] ([77.2.78.131]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MAP77-1pMeAu3XFT-00BpPs; Mon, 20 Feb 2023 14:07:27 +0100
Message-ID: <f1f102dc-0e9a-4a13-1e40-f4c3d594fe7e@metux.net>
Date:   Mon, 20 Feb 2023 14:07:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: RFC: shall we have a baseband subsystem ?
Content-Language: tl
To:     platform-driver-x86@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        isdn@linux-pingi.de
References: <20230113231139.436943-1-philipp@redfish-solutions.com>
 <44e0ef20-d6d3-4c87-1828-f88dbc08e942@redhat.com>
 <7f5644a8-2e6f-b4c6-4db8-2419d1a7f005@metux.net>
 <48beb1c5-5136-a287-1a74-bdc558bffe3e@wildgooses.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
In-Reply-To: <48beb1c5-5136-a287-1a74-bdc558bffe3e@wildgooses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vv9F4NyMh6vUI+tw/EyExBNzQXIMuyenETIWWlm+TV7N2oBo53u
 K0It3+xrz3NQrzlslBqG276mtLxVAT5cIgeW4OZFVAPswpUpbOw6vVqI+jh8/XCbg+fiDa/
 bVNEIK7dlmIddoGSWOSqjJAG676VYJW6LLfS5HtkTVNpyJr0hXLIhcUj3xJBTUkiNOkC/pW
 1RjC6pZFM/w21zmLBkfhw==
UI-OutboundReport: notjunk:1;M01:P0:2b2YihBhKJo=;KyBhkNudcj6r+eMb/eJHR8eKUfM
 lZFLYXeVK/b7W42L6x9x5nxj51PQTP6vRT0W7G7d2/LxGWzUHWTvSnLhJBs+7edEFba8a3xm4
 99YgZD2XRdoPe5wa9sckzXB/pE1J08dLsegylhwuSjHSCwQQLYnQ6dGisKGTkI/2Va3CM+Era
 RFCJajnCGGwOK04FqsT44tU0Vci9EsR72Ku5+zwakQ7fuT3soZiAcsb6HkiQb+efA6Zee2j4U
 XYYRx1Octn8uC4GcAGao8j/FOou4jcDJHkjantEjFQvmdwI+rrwuwH3ZivhdIb+Es5M98Kia7
 4Wc1omjVJ9bmBAI7vsX36+bTHuSMh6vxs01/fQSBwUT71frjKLqxRqdEWGvfnzfeDHWvjey0o
 1SsreL5QZaXkeEHsecHxKAOIsCeGCljwJTz/OHt9l4daXxK1kKqc80KZeB+WqlcU2AVrgk9X4
 02OfkyJxkOfusYnfRtOrbgrpR9c3of1CzpJ+4/jsyHKc4X8YBi3WIGGH5vkPMX/i5bTkwz/t0
 M1MyUbsuFXQ6m/nGcN59Oa4C76y209AMH1mdrxD6KTom7ky9KtmfkhGYSib//5Uxns6fKhFki
 ReYW2us4SzODHvtaKsw6edJqYwN2OZVlHrnp7CoBlZrpkud6qIwpQoQ6HYZcRhrwYBzuf6Lm2
 REkH0bYd8wmgU0j4cX30VaS1OHqCGwMZDYF/kcjOOw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello folks,


in recent times we had several discussions on issues related to
controlling various baseband controllers, which tend to be quite
board specific - for example:

* RST lines on APU board family's M2 slots, which can be used to
   devices in there, eg. modems (actual GPIO is model specific)
* switchable power supply (onboard basebands)
* SIM-slot multiplexers (also on APU)
* RF exposure sensors for TX strength regulation
* active antenna or boosters
* fly-mode (rfkill)

Originally I thought about extending rfkill, but quickly turned out that
there're too many aspects in here that are way ouf of scope for rfkill.
Similar for isdn4linux. And seems netdev the right place, since it 
usually comes into play much later, when an actual connection is made.

The biggest challenge from userland/application side IMHO is probing the
presence of those feature and the actual connection between individual
pieces. Since the kernel usually knows best about the current HW setup
and serves as an universal HAL in many many other places, I believe that
it also should carry the necessary knowledge of those stuff, too.

I'm currently thinking of a new device class, representing the whole
baseband setup with its surrounding peripherals in sysfs. There we'll
find several entries, eg.:

* model information, supported protocols and interfaces
* link to the tty device (if it's speaking AT commands)
* enumerating and setting sim slot choices
* get / set power state
* trigger HW reset
* get/set TX limits
* booster configuration
* link to netdev (if applicable)
* link to rfkill
* link to mixer/dsp channels for direct mic links
...


Userland can now query this information or act on these devices in 
standard way, no need to care about individual HW details anymore.
Even on an average PC, this can make detection of connected basebands
easier (eg. no need to configure the tty device name, ...)

Probing probably needs some callbacks for dealing with hotplug, so board
drivers can act when some other subsys detects a device that might be a
baseband. For example on the APU boards, basebands are connected via
USB, so we have to hook in here and let the board driver check whether 
the new USB device is a baseband and in which HW slot it's in - and in
this case it sets up baseband device and connects all other peripherals.

Actually, I'm not fully settled on the naming yet - "baseband" was just
the first to come in mind, but this should also work for other devices
like wifi (hmm, maybe even some wired ones ?).


What's you oppinion on that ?


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
