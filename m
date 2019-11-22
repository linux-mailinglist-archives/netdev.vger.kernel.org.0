Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33D9106721
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKVHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:37:18 -0500
Received: from sonic312-27.consmr.mail.ir2.yahoo.com ([77.238.178.98]:34920
        "EHLO sonic312-27.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfKVHhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:37:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574408234; bh=H4mHigrNn9+3LdpUqt41Xx7nDE8Ws1z4hOZCC0NAOAk=; h=Date:From:Reply-To:Subject:From:Subject; b=SS2ED8QPMUt88i+NpOQmnSu1ZEoZY06qyYMFNyV7X6ZBI27PVjChmXfa2nDt0Ru+nWPHvI0205BJHLy9N6gLq5yROdmoZo+EKthaUK+15vgEEAbUJsomkA1bZWYuDxUCHKlDUTGdYs0ULXUnxUMvKg9P6SGZ60OY02ZlBdPYrZsXANF0MEplQ2SlJot8fLVXrJ+EO8dj83huJP+3FIOA7l5jimc6jYmBK+ynDIsxt13tuDvlLcTc7JQS7xcxuyXSywKUoCAnQ4aoiACHYPIk31sPMRiT9aj/Rz99eJlOYPVx0ttyzKr44BxJUPwab3LQZmun94h8hIBg3BokqCfQ2g==
X-YMail-OSG: hOPAa_cVM1mO.gEOtaU_jSby0s2kTNTHvSGPdXGbPj4CXJnzthGBQ.hpqPIIHzD
 k4kfxmHBfBkcX6aBNyyKNDNrLf56gbUCiuShlknqiI.IH0QyK16zmUnDm2MQcGWopTxe8dhwiKJj
 25TPXvdbH18pHixIXQKEYMFk7juh4DMBzpI5q4AL5s9v_sO7oLud745vrmPR3GetErfzVaUkoycM
 Ekw201dGeBDY3J4lD2j3KDR6c7a147OstH6Tl9ZC0ysCSI1MqhOoeaBN5I2oyPrk2an8M0tbOV2A
 spyKxWdlV0sgm79LZ8u4CEDjnUjYWv9ItrQ_nspn4nX0fC6JjG0vJk4z_7ug9yymsC2xADFgbfxP
 H3ALYmXM_6BSupFnZ03uKNkkw_EDmn4TaJTnFjJ4Zvy58tCcHl84wIGqnUQv9UeFy5NYI4Uw9qa.
 nz5tKXpwB2NA.ZCIuNfxELh_OvEyrbwmhTurPok2qtk5SGqUjGrGqilgwxEBCvFgSMJnDVZ9UXwi
 UiYV3EWkqE1DMBjQCF1NRGIjNJzob5I4aFHSaJrVCbf6byJohXgsDGVUpUsZOYzpwILvMHXI_7.W
 _WqwXGCwAEwQ2gl.8BPAWRH5QapLT_W32lhiGaRxOLuIDmv8qDg5985D6huGRprAEV6Pq1NRQSkn
 vhyMdf.VFA1F7O3KAjCp1FqApm7tQlL3gtMUa15GkoOdaIUe2ln_e.yZyW10_TQnocZOMfIsmdm0
 LQONbq501u22BCL5sVD.yHzo0BtrZoMRlbS1mS16ZXK4dclwRZIfl.uPDiRrxQDaD7wSlJLybIUy
 VUSdcIw5Zr7KvBdfqfNX.zJ9IebgQ6XbF_lDf396h.X54W1Pd_3XLlG1eYK.B_A1AxUIoIVDS9Ju
 BO8mA7D8TJQ1XXhQWhNB0RCZsIsKjM8tlEJ.KRaLpfjow4GXT3og4eXdTNwWDQf9L6k302WHW6Zr
 SbMEgs6N_d2jBe2cPgZXmewOuf_ABVXuFfR15cGeP3VgdjzJOv4jQ9JnnX3bEwSEAajyxken2r8B
 uFXvIq2ML5k7ZtisOPCuhLaGHwXHR8sG1XsgPed3_gDvA03xwB4Dnd1Frl5vTD6lSVZroBOT0llr
 y9QQ6b3bWJ3ElENZ7lGkQ_kiERGQWAW95hHH7gG6huCHg8K3HQQuzqZCV10GHlv5i8zKfjYZn8HE
 WIH91lJ6NzWHENDPK5bv518raJqplRyEUjxXseN5XbIi5FxUpnXQPbVGR.A03A4w4tNHyzqzS.GF
 N37ASLOZ.jG475..ibORqf.KnEl1vyGhxnvChuhpLhTokQbsphqAcq7a.WNyhdOCSw7rUV_dPOA-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ir2.yahoo.com with HTTP; Fri, 22 Nov 2019 07:37:14 +0000
Date:   Fri, 22 Nov 2019 07:37:13 +0000 (UTC)
From:   Lamizana Mariam <investmentltd2@gmail.com>
Reply-To: lamizana.mariam@yahoo.com
Message-ID: <1979273245.6615640.1574408233515@mail.yahoo.com>
Subject: Attention: To Whom It May Concern
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Attention: To Whom It May Concern

I know you will be surprised to read my email. Apart from being surprise you may be skeptical to reply me because based on what is happening around the internet globally, I am aware of insecurity on internet, But that does not mean that genuine business does not exist when it comes through internet. No, I am assuring you that my proposal has nothing to do with scam going on the internet and do not allow that to over-influence you on whatever business that comes your way.

I believe you may be in a position to assist for me for this my proposed transaction, It is Raw Gold of 50 kilograms( Current average values estimated 2 399 246.5 US Dollars.), I am looking for a trust worthy individual who will help me and also whom I can confided with because this said goods is an inheritance and I want to leave my country for a new life in any part of the world because of the socio-political situation of my country and my problem I am facing is exportation aspect here, we needed funds for documentations and fees for the export.

If you will assist me and after the sale of the gold, I am ready to offer you 20 percent of the total sales and as soon as the said goods arrive the shore the final destination that is your country I will join you in your country also you will help on which kind of investment will put my own part of the fund into?

I assure you it is risk free, this transaction will be done legally and need honesty and confidentiality. I will follow any advice you may desire to give me for us to be successful in this transaction.

Please do not reply to my ad if you are not interested! Because I need a serious partner, and keep your insults to you.

Thanking you in advance with my sincerely heart to you.

Madam Lamizana Mariam
